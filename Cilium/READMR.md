# Cilium Installation and Configuration Guide

## 1. Installing Cilium

1. **Verify Kubernetes Environment**:
   - Auto-detection of Kubernetes kind: `kind`
   - Detected kind version: `0.20.0`
   - Using Cilium version: `v1.14.1`

2. **Installation Command**:
   ```bash
   cilium install
   ```
   Wait approximately one minute for the installation to complete.

3. **Check Installation Status**:
   ```bash
   cilium status --wait
   ```

## 2. Deploying the Star Wars Demo

### Description
This demo showcases microservice applications inspired by Star Wars:
- Death Star: `org=empire`, `class=deathstar`
- Imperial TIE fighter: `org=empire`, `class=tiefighter`
- Rebel X-Wing: `org=alliance`, `class=xwing`

### Steps
1. **Deploy Demo Application**:
   ```bash
   kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/HEAD/examples/minikube/http-sw-app.yaml
   ```

2. **Verify Deployment**:
   ```bash
   kubectl get pods,svc
   ```
   Re-run the command until all pods are in the `Running` state.

3. **View Cilium Endpoints**:
   ```bash
   kubectl get cep --all-namespaces
   ```

## 3. Testing Access

### Commands
1. **Test TIE Fighter Landing on Death Star**:
   ```bash
   kubectl exec tiefighter -- \
     curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing
   ```
   Expected: Access granted (TIE Fighter and Death Star are on the same side).

2. **Test X-Wing Landing on Death Star**:
   ```bash
   kubectl exec xwing -- \
     curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing
   ```
   Expected: Access allowed (current policy allows this, but it should be restricted).

## 4. Implementing Security Policies

### Crafting a Network Policy
- **Goal**: Restrict Death Star access to Empire ships only.
- **Example Policy**:
  ```yaml
  apiVersion: cilium.io/v2
  kind: CiliumNetworkPolicy
  metadata:
    name: rule1
  spec:
    endpointSelector:
      matchLabels:
        org: empire
        class: deathstar
    ingress:
    - fromEndpoints:
      - matchLabels:
          org: empire
      toPorts:
      - ports:
          - port: "80"
            protocol: TCP
  ```

### Applying the Policy
1. **Apply Preconfigured Policy**:
   ```bash
   kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/HEAD/examples/minikube/sw_l3_l4_policy.yaml
   ```

2. **Test Access**:
   - TIE Fighter: Should be allowed.
   - X-Wing: Should be denied.

### Creating a Custom Policy
1. **File Path**: `/root/policies/sneak.yaml`
2. **Policy Specification**:
   ```yaml
   apiVersion: cilium.io/v2
   kind: CiliumNetworkPolicy
   metadata:
     name: rule1
     namespace: default
   spec:
     endpointSelector:
       matchLabels:
         class: deathstar
         organization: empire
     ingress:
     - fromEndpoints:
       - matchLabels:
           class: tiefighter
           organization: empire
       toPorts:
       - ports:
           - port: "80"
             protocol: TCP
   ```

3. **Apply the Policy**:
   ```bash
   kubectl apply -f /root/policies/sneak.yaml
   ```

4. **Testing**:
   - **TIE Fighter Access**:
     ```bash
     kubectl exec tiefighter -- curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing
     ```
     Expected: Allowed.
   - **X-Wing Access**:
     ```bash
     kubectl exec xwing -- curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing
     ```
     Expected: Denied.

## 5. Notes
- For visualizing policies, use the [Cilium Network Policy Editor](https://editor.cilium.io).
- Policies can be updated and re-applied as needed.

## 6. Advanced Security
To enforce stricter security:
- Limit microservices to only the necessary HTTP requests.
- Use least-privilege isolation principles.

Ensure that the X-Wing cannot access the Death Star under any circumstances. By refining and applying targeted policies, the system's security can be enhanced.

### -----------------------------------------------------------------------

# Installing Cilium as the Kubernetes Network Driver

## Prerequisites

1. **Kubernetes Cluster**: Ensure you have a running Kubernetes cluster.
   - Verify using:
     ```bash
     kubectl get nodes
     ```

2. **CLI Tools**: Install `kubectl` and `helm` on your machine.
   - **Install Helm** (if not installed):
     ```bash
     curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
     ```

3. **Networking Requirements**:
   - Cilium supports various data planes like eBPF. Ensure your kernel supports eBPF.
     ```bash
     uname -r
     ```
     Kernel version should be 4.19 or later.

## Installing Cilium Using Helm

1. **Add the Cilium Helm Repository**:
   ```bash
   helm repo add cilium https://helm.cilium.io/
   helm repo update
   ```

2. **Install Cilium**:
   Use Helm to install Cilium with default configuration:
   ```bash
   helm install cilium cilium/cilium --namespace kube-system
   ```

   Alternatively, customize installation options:
   ```bash
   helm install cilium cilium/cilium --namespace kube-system \
     --set kubeProxyReplacement=strict \
     --set ipam.mode=cluster-pool \
     --set tunnel=geneve
   ```
   - **`kubeProxyReplacement`**: Enables eBPF-based kube-proxy replacement.
   - **`ipam.mode`**: Choose `cluster-pool` or `eni` based on your environment.
   - **`tunnel`**: Choose the encapsulation mode (`vxlan`, `geneve`, or `disabled`).

3. **Validate Installation**:
   Confirm that Cilium is running:
   ```bash
   kubectl -n kube-system get pods -l k8s-app=cilium
   ```

   Check logs for any issues:
   ```bash
   kubectl -n kube-system logs -l k8s-app=cilium
   ```

4. **Enable Cilium CLI** (Optional):
   Install the Cilium CLI for advanced management and troubleshooting:
   ```bash
   curl -L --remote-name https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz
   tar xzvf cilium-linux-amd64.tar.gz
   sudo mv cilium /usr/local/bin/
   ```

   Validate connectivity:
   ```bash
   cilium status
   ```

## Post-Installation Configuration

1. **Deploy a Sample Application**:
   Deploy a test application to ensure connectivity:
   ```bash
   kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/v1.14/examples/kubernetes/connectivity-check/connectivity-check.yaml
   ```

   Monitor test results:
   ```bash
   kubectl get pods -n cilium-test
   ```

2. **Enable Hubble (Optional)**:
   Hubble is Cilium's observability and monitoring tool.
   - Install Hubble:
     ```bash
     helm upgrade --install cilium cilium/cilium --namespace kube-system \
       --set hubble.relay.enabled=true \
       --set hubble.ui.enabled=true
     ```
   - Access the Hubble UI:
     ```bash
     kubectl port-forward -n kube-system svc/hubble-ui 12000:80
     ```

## Verify Network Driver

Check the CNI configuration on your cluster:
```bash
kubectl get pods -n kube-system
```

Ensure `cilium` pods are running without issues.

---

Follow these steps to install and configure Cilium as your Kubernetes network driver successfully. Let me know if you need further assistance!
