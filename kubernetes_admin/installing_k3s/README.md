# k3s HA on Bare Metal (3 masters + 2 workers) — with keepalived VIP

## Topology (adjust if needed)

* **VIP (Kubernetes API):** `192.168.50.10`
* **Masters:**

  * master1: `192.168.50.11`
  * master2: `192.168.50.12`
  * master3: `192.168.50.13`
* **Workers:**

  * worker1: `192.168.50.21`
  * worker2: `192.168.50.22`

> OS: Ubuntu/Debian (root or sudo). If using RHEL-like, replace apt commands with yum/dnf and ensure `ss` is available (`iproute`).

---

## 0) ALL NODES — prerequisites (masters + workers)

```bash
sudo bash -c '
set -euo pipefail

apt-get update -y
apt-get install -y curl ca-certificates gnupg lsb-release jq iproute2

# disable swap now and permanently
swapoff -a || true
sed -ri "s@^([^#].*\s)swap(\s)@#\1swap\2@g" /etc/fstab

# kernel sysctls for k8s networking
modprobe br_netfilter || true
cat >/etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
EOF
sysctl --system

# basic time sync (recommended)
apt-get install -y systemd-timesyncd || true
systemctl enable --now systemd-timesyncd || true
'
```

> If a firewall is enabled, allow at least: **TCP 6443** (API). Node-to-node traffic must be open inside the cluster network.

---

## 1) MASTERS ONLY — install keepalived VIP (same block on each master)

> Paste this **unchanged** on **master1**, **master2**, and **master3**.
> If your IPs differ, edit the four variables at the top before pasting.

```bash
sudo bash -c '
set -euo pipefail

# === EDIT HERE IF YOUR IP PLAN DIFFERS ===
VIP="192.168.50.10"
MASTERS=("192.168.50.11" "192.168.50.12" "192.168.50.13")
VRID="51"              # 0-255, keep same on all masters
PASS="k3s-keepalived"  # VRRP auth pass, same on all masters
# =========================================

apt-get update -y
apt-get install -y keepalived iproute2 jq

# detect primary interface to reach VIP
IFACE="$(ip route get "$VIP" 2>/dev/null | awk '\''/dev/ {for(i=1;i<=NF;i++) if($i=="dev"){print $(i+1); exit}}'\'')"
[ -z "$IFACE" ] && IFACE="$(ip route show default | awk '\''/default/ {print $5; exit}'\'')"
[ -z "$IFACE" ] && { echo "ERROR: cannot detect interface"; exit 1; }

LOCAL_IP="$(ip -4 -o addr show dev "$IFACE" | awk '"'"'{print $4}'"'"' | cut -d/ -f1 | head -n1)"
[ -z "$LOCAL_IP" ] && { echo "ERROR: cannot detect local IPv4 on $IFACE"; exit 1; }

# set priority: first master in list is highest
PRIO=200
for idx in "${!MASTERS[@]}"; do
  if [ "${MASTERS[$idx]}" = "$LOCAL_IP" ]; then PRIO=$((250 - idx)); fi
done

# health check: VIP stays only if API :6443 is listening locally
install -m 0755 /dev/stdin /usr/local/sbin/check_k3s.sh <<'"EOF"'
#!/usr/bin/env bash
ss -Htan | awk '"'"'{print $4}'"'"' | grep -qE ":(^|.*:)6443$"
EOF

# notify hook for journald logs
install -m 0755 /dev/stdin /usr/local/sbin/keepalived-notify.sh <<'"EOF"'
#!/usr/bin/env bash
TYPE="$1"; NAME="$2"; STATE="$3"
logger -t keepalived "VRRP transition: ${NAME} -> ${STATE} on $(hostname)"
EOF

# build unicast peers = other masters
PEERS=()
for ip in "${MASTERS[@]}"; do
  [ "$ip" != "$LOCAL_IP" ] && PEERS+=("$ip")
done

install -d /etc/keepalived
cat >/etc/keepalived/keepalived.conf <<EOF
vrrp_script chk_k3s {
  script "/usr/local/sbin/check_k3s.sh"
  interval 2
  timeout 2
  fall 2
  rise 1
}

vrrp_instance VI_${VRID} {
  state BACKUP
  interface ${IFACE}
  virtual_router_id ${VRID}
  priority ${PRIO}
  advert_int 1
  nopreempt
  garp_master_delay 1

  authentication {
    auth_type PASS
    auth_pass ${PASS}
  }

  unicast_src_ip ${LOCAL_IP}
  unicast_peer {
$(for p in "${PEERS[@]}"; do echo "    ${p}"; done)
  }

  track_script {
    chk_k3s
  }

  virtual_ipaddress {
    ${VIP}/32 dev ${IFACE}
  }

  notify "/usr/local/sbin/keepalived-notify.sh"
}
EOF

systemctl enable --now keepalived
systemctl status --no-pager keepalived || true

echo "Keepalived configured on $(hostname): VIP=${VIP} IFACE=${IFACE} PRIO=${PRIO} PEERS=${PEERS[*]}"
'
```

**Sanity check (on one master):**

```bash
ip addr | grep -A2 "192.168.50.10" || true
```

You should see the VIP bound on **one** of the masters (it will move automatically on failover).

---

## 2) MASTER 1 — bootstrap the cluster (embedded etcd)

```bash
sudo bash -c '
set -euo pipefail
VIP="192.168.50.10"
THIS_NODE_IP="192.168.50.11"  # master1 IP

# generate and persist a secure join token
K3S_TOKEN="$(openssl rand -hex 32)"
echo "$K3S_TOKEN" > /root/k3s-ha.token
chmod 600 /root/k3s-ha.token

# install k3s server (control-plane + etcd)
curl -sfL https://get.k3s.io | \
  INSTALL_K3S_EXEC="server \
    --cluster-init \
    --node-ip ${THIS_NODE_IP} \
    --advertise-address ${THIS_NODE_IP} \
    --tls-san ${VIP} \
    --tls-san ${THIS_NODE_IP} \
    --disable traefik \
    --disable servicelb \
    --write-kubeconfig-mode 0644" \
  sh -s -

echo "Master1 up. Kubeconfig: /etc/rancher/k3s/k3s.yaml"
'
```

**Wait until the API is ready:**

```bash
kubectl get nodes
```

---

## 3) MASTER 2 — join the control plane

```bash
sudo bash -c '
set -euo pipefail
VIP="192.168.50.10"
THIS_NODE_IP="192.168.50.12"   # master2 IP
MASTER1_IP="192.168.50.11"

# pull token from master1 (requires SSH access), or copy it manually
K3S_TOKEN="$(ssh -o StrictHostKeyChecking=no root@${MASTER1_IP} cat /root/k3s-ha.token)"

curl -sfL https://get.k3s.io | \
  K3S_TOKEN="${K3S_TOKEN}" \
  INSTALL_K3S_EXEC="server \
    --server https://${VIP}:6443 \
    --node-ip ${THIS_NODE_IP} \
    --advertise-address ${THIS_NODE_IP} \
    --tls-san ${VIP} \
    --tls-san ${THIS_NODE_IP} \
    --disable traefik \
    --disable servicelb \
    --write-kubeconfig-mode 0644" \
  sh -s -

echo "Master2 joined."
'
```

---

## 4) MASTER 3 — join the control plane

```bash
sudo bash -c '
set -euo pipefail
VIP="192.168.50.10"
THIS_NODE_IP="192.168.50.13"   # master3 IP
MASTER1_IP="192.168.50.11"

K3S_TOKEN="$(ssh -o StrictHostKeyChecking=no root@${MASTER1_IP} cat /root/k3s-ha.token)"

curl -sfL https://get.k3s.io | \
  K3S_TOKEN="${K3S_TOKEN}" \
  INSTALL_K3S_EXEC="server \
    --server https://${VIP}:6443 \
    --node-ip ${THIS_NODE_IP} \
    --advertise-address ${THIS_NODE_IP} \
    --tls-san ${VIP} \
    --tls-san ${THIS_NODE_IP} \
    --disable traefik \
    --disable servicelb \
    --write-kubeconfig-mode 0644" \
  sh -s -

echo "Master3 joined."
'
```

---

## 5) WORKERS — join as agents (repeat per worker)

### worker1

```bash
sudo bash -c '
set -euo pipefail
VIP="192.168.50.10"
MASTER1_IP="192.168.50.11"
THIS_NODE_IP="192.168.50.21"

K3S_TOKEN="$(ssh -o StrictHostKeyChecking=no root@${MASTER1_IP} cat /root/k3s-ha.token)"
curl -sfL https://get.k3s.io | \
  K3S_URL="https://${VIP}:6443" \
  K3S_TOKEN="${K3S_TOKEN}" \
  INSTALL_K3S_EXEC="agent --node-ip ${THIS_NODE_IP}" \
  sh -s -

echo "Worker1 joined."
'
```

### worker2

```bash
sudo bash -c '
set -euo pipefail
VIP="192.168.50.10"
MASTER1_IP="192.168.50.11"
THIS_NODE_IP="192.168.50.22"

K3S_TOKEN="$(ssh -o StrictHostKeyChecking=no root@${MASTER1_IP} cat /root/k3s-ha.token)"
curl -sfL https://get.k3s.io | \
  K3S_URL="https://${VIP}:6443" \
  K3S_TOKEN="${K3S_TOKEN}" \
  INSTALL_K3S_EXEC="agent --node-ip ${THIS_NODE_IP}" \
  sh -s -

echo "Worker2 joined."
'
```

---

## 6) Verify cluster (run on any master)

```bash
# nodes
kubectl get nodes -o wide

# core components (etcd as static pods on masters)
kubectl get pods -A | sort

# observe VIP sits on exactly one master
ip addr | grep -A2 "192.168.50.10" || true
```

**etcd health (from a master):**

```bash
kubectl -n kube-system exec -it etcd-$(hostname) -- etcdctl \
  --cacert=/var/lib/rancher/k3s/server/tls/etcd/server-ca.crt \
  --cert=/var/lib/rancher/k3s/server/tls/etcd/server-client.crt \
  --key=/var/lib/rancher/k3s/server/tls/etcd/server-client.key \
  endpoint status --write-out=table
```

---

## 7) Use kubectl from your laptop (optional)

```bash
# on master1, copy kubeconfig to a safe place
sudo cat /etc/rancher/k3s/k3s.yaml | sed "s|server: .*|server: https://192.168.50.10:6443|" > ~/kubeconfig-k3s-ha.yaml
chmod 600 ~/kubeconfig-k3s-ha.yaml
# download this file to your workstation and:
# export KUBECONFIG=/path/to/kubeconfig-k3s-ha.yaml
# kubectl get nodes
```

---

## 8) Backups (etcd snapshots)

k3s auto-enables local etcd snapshots. Quick manual snapshot:

```bash
# on a master
k3s etcd-snapshot save --name on-demand-$(date +%F-%H%M%S)
ls -1 /var/lib/rancher/k3s/server/db/snapshots/
```

Restore procedure (reference only; do not run unless needed):

```bash
# STOP k3s on all masters first, then on master1:
systemctl stop k3s
k3s server --cluster-init --cluster-reset --cluster-reset-restore-path=/path/to/snapshot.db
# when it exits, start k3s:
systemctl start k3s
# then rejoin other masters as in steps 3/4 (using the same token)
```

---

## 9) Upgrade k3s (rolling)

```bash
# ONE NODE AT A TIME (masters first), on the node you upgrade:
systemctl stop k3s || systemctl stop k3s-agent || true
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION= # e.g., v1.30.x  sh -s -
systemctl start k3s || systemctl start k3s-agent || true
kubectl get nodes
```

> Keepalived will keep the VIP on a healthy master while others roll.

---

## 10) Uninstall (if you need to reset)

```bash
# masters
/usr/local/bin/k3s-uninstall.sh || true
systemctl disable --now keepalived || true
rm -rf /etc/keepalived /usr/local/sbin/check_k3s.sh /usr/local/sbin/keepalived-notify.sh

# workers
/usr/local/bin/k3s-agent-uninstall.sh || true
```

---

## Notes & Best Practices

* We **disable Traefik + ServiceLB** to keep control-plane minimal. Add your own ingress (e.g., NGINX Ingress) and LB (e.g., MetalLB) later.
* Make sure SSH from masters to **master1** works (for fetching the token). If not, copy `/root/k3s-ha.token` manually to the other nodes.
* If you use **UFW**, open intra-cluster traffic or disable UFW on cluster NICs. At minimum: `ufw allow 6443/tcp`.
* If your network isn’t `192.168.50.0/24`, just edit the variables at the top of sections 1–5.

---

### TL;DR

1. Run **Section 0** on all five nodes.
2. Run **Section 1** on each master (installs VIP).
3. Run **Section 2** on master1.
4. Run **Sections 3 & 4** on master2 & master3.
5. Run **Section 5** on worker1 & worker2.
6. Verify with **Section 6**.

that’s it — hand this README to your teammate and they can copy-paste straight through. if you want, tell me your *actual* five IPs and i’ll bake them into the commands so they truly don’t have to edit anything.
