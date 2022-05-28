# How to install Ceph on kubernetes?  

### Step 1: install rook/ceph:
```commandline
kubectl create namespace rook-ceph
helm install rook-ceph rook-release/rook-ceph -n rook-ceph --version v1.7.3
```
### Step 2: Go to all worker nodes and:
```commandline
dd if=/dev/zero of=/dev/sdb bs=1M status=progress count=1000
```
`/dev/sdb` is the volume you want to develop ceph on  
`bs=1M` block size  
`count=1000` block count
### Step 3:
Clone rook on worker pods:
```commandline
git clone https://github.com/rook/rook.git
```
### Step 3: Go to rook directory:
```commandline
kubectl --n rook-ceph apply -f cluster/examples/kubernetes/ceph/cluster.yaml
kubectl --n rook-ceph apply -f cluster/examples/kubernetes/ceph/csi/rbd/storageclass.yaml
```
### Step 4: Setup dashboard:
Create a manifest `dashboard-external-https.yaml`:
```yaml
apiVersion: v1
kind: Service
metadata:
   name: rook-ceph-mgr-dashboard-external-https
   namespace: rook-ceph
   labels:
     app: rook-ceph-mgr
     rook_cluster: rook-ceph
spec:
   ports:
   - name: dashboard
     port: 8443
     protocol: TCP
     targetPort: 8443
     
   selector:
     app: rook-ceph-mgr
     rook_cluster: rook-ceph
   sessionAffinity: None
   type: NodePort' > dashboard-external-https.yaml
```
Run:
```commandline
kubectl create -f dashboard-external-https.yaml
```
