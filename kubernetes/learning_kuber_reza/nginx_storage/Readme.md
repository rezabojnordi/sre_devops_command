* First lets install NFS server on the host machine, and create a directory where our NFS server will serve the files:
* 
```
sudo systemctl status nfs-server
sudo apt install nfs-kernel-server nfs-common portmap
sudo start nfs-server
mkdir -p /srv/nfs/mydata 
chmod -R 777 nfs/ # for simple use but not advised
```
* Exporting our directory, note that this is an insecure configuration do no use in production:
```
$ sudo vi /etc/exports
/srv/nfs/mydata  *(rw,sync,no_subtree_check,no_root_squash,insecure)
$ sudo exportfs -rv
exporting *:/srv/nfs/mydata
$ showmount -e
/srv/nfs/mydata  *
```

* Login to the kubernetes cluster, in this case minikube, user: docker; passwd: tcuser, making sure that minikube can ping the localhost and mounting the NFS server in minikube:

```
$ kubectl get nodes
$ minikube ip
192.168.99.157
$ ssh docker@192.168.99.157
# ping localhostip
$ showmount 192.168.1.7
Hosts on 192.168.1.7:
$ mount -t nfs 192.168.1.7:/srv/nfs/mydata /mnt
$ mount | grep mydata
192.168.1.7:/srv/nfs/mydata on /mnt type nfs4
$ exit
```
nfs.yaml
```

apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-pv
  labels:
    name: mynfs # name can be anything
spec:
  storageClassName: manual # same storage class as pvc
  capacity:
    storage: 200Mi
  accessModes:
    - ReadWriteMany
  nfs:
    server: 192.168.1.7 # ip addres of nfs server
    path: "/srv/nfs/mydata2" # path to directory
```

Deploying nfs.yaml:
```
$ kubectl apply -f nfs.yaml
$ kubectl get pv,pvc
persistentvolume/nfs-pv   100Mi      RWX            Retain           Available
```
* 3. Creating persistence volume claim file and deploying it. The accessModes must be the same as the persistence volume that it needs to access:


nfs-pvc.yaml
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs-pvc
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteMany #  must be the same as PersistentVolume
  resources:
    requests:
      storage: 50Mi
```

```
$ kubectl apply -f nfs_pvc.yaml
$ kubectl get pvc,pv
persistentvolumeclaim/nfs-pvc   Bound    nfs-pv   100Mi      RWX
```
* Lets create a pod to access this pvc using a simple Nginx deployment. The most important line is the claimName which must be the same as the persistence volume claim that the application will use:
  
nfs-pod.yaml
```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    app: nginx
  name: nfs-nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      volumes:
      - name: nfs-test
        persistentVolumeClaim:
          claimName: nfs-pvc # same name of pvc that was created
      containers:
      - image: nginx
        name: nginx
        volumeMounts:
        - name: nfs-test # name of volume should match claimName volume
          mountPath: /usr/share/nginx/html # mount inside of contianer
```

* Deploying Nginx:

```
$ kubectl apply -f nfs_pod.yaml 
$ kubectl get po
nfs-nginx-6cb55d48f7-q2bvd   1/1     Running
```
* Testing

* Creating a test.html in the Nginx pod:
```
$ kubectl exec -it nfs-nginx-6cb55d48f7-q2bvd bash
$ sudo vi /usr/share/nginx/html/test.html
<h1. this should hopefully work</h1>
```

* Verifying that the host machine has now the same file and verifying that Nginx can read the file:

```
$ ls /srv/nfs/mydata$
$ cat /srv/nfs/mydata/test.html
<h1>this should hopefully work</h1>
$ kubectl expose deploy nfs-nginx --port 80 --type NodePort
$ kubectl get svc
$ nfs-nginx    NodePort    10.102.226.40   <none>        80:32669/TCP
```
* Deleting

```
$ kubectl delete deploy nfs-nginx
$ kubectl delete pvc nf-pvc
--> kubectl delete svc nfs-nginx
$ ls /srv/nfs/mydata/
test.html
```

## Dynamic NFS provisioning

The problem with the previous method is that someone has to create each persistence volume for all pvc requests, which can be time consuming. A way to solve this is to have an NFS client that will automatically do it for us. Requesting a persistence volume claim will automatically trigger the creation of a persistence volume. For this to happen an NFS client must be installed in the kubernetes cluster, and access must be given to the client using a service account.

* Configuring NFS server using a new directory:

```
$ mkdir -p /srv/nfs/mydata2
$ chown 777 /srv/nfs/mydata2
$ vi /etc/exports
  --> add new path to directory see example in first part
$ sudo exportfs -rv
$ showmoount -e 
```
Login to the kubernetes cluster and follow the steps above to mount the new directory, adding mydata2 this time.

2 . Service account must be set using a yaml.file, it will create role, role binding, and various roles within the kubernetes cluster. If you need to understand what are service accounts : here.

vim rbac.yaml 
```
kind: ServiceAccount
apiVersion: v1
metadata:
  name: nfs-pod-provisioner-sa
---
kind: ClusterRole # Role of kubernetes
apiVersion: rbac.authorization.k8s.io/v1 # auth API
metadata:
  name: nfs-provisioner-clusterRole
rules:
  - apiGroups: [""] # rules on persistentvolumes
    resources: ["persistentvolumes"]
    verbs: ["get", "list", "watch", "create", "delete"]
  - apiGroups: [""]
    resources: ["persistentvolumeclaims"]
    verbs: ["get", "list", "watch", "update"]
  - apiGroups: ["storage.k8s.io"]
    resources: ["storageclasses"]
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources: ["events"]
    verbs: ["create", "update", "patch"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: nfs-provisioner-rolebinding
subjects:
  - kind: ServiceAccount
    name: nfs-pod-provisioner-sa # defined on top of file
    namespace: default
roleRef: # binding cluster role to service account
  kind: ClusterRole
  name: nfs-provisioner-clusterRole # name defined in clusterRole
  apiGroup: rbac.authorization.k8s.io
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: nfs-pod-provisioner-otherRoles
rules:
  - apiGroups: [""]
    resources: ["endpoints"]
    verbs: ["get", "list", "watch", "create", "update", "patch"]
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: nfs-pod-provisioner-otherRoles
subjects:
  - kind: ServiceAccount
    name: nfs-pod-provisioner-sa # same as top of the file
    # replace with namespace where provisioner is deployed
    namespace: default
roleRef:
  kind: Role
  name: nfs-pod-provisioner-otherRoles
  apiGroup: rbac.authorization.k8s.io
```
* Deploying the service account:

```
kubectl apply -f rbac.yaml
kubectl get clusterrole,role 
```
vim nfs_class.yaml
```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: nfs-storageclass # IMPORTANT pvc needs to mention this name
provisioner: nfs-test # name can be anything
parameters:
  archiveOnDelete: "false"

```

```
kubectl create -f nfs_class.yaml
kubectl get storageclass
```
* The NFS client provisioner will be set as a pod, here is the github link.

vim nfs_pod_provision.yaml

```
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: nfs-pod-provisioner
spec:
  replicas: 1
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: nfs-pod-provisioner
    spec:
      serviceAccountName: nfs-pod-provisioner-sa # name of service account created in rbac.yaml
      containers:
        - name: nfs-pod-provisioner
          image: quay.io/external_storage/nfs-client-provisioner:latest
          volumeMounts:
            - name: nfs-provisioner-v
              mountPath: /persistentvolumes
          env:
            - name: PROVISIONER_NAME # do not change
              value: nfs-test # SAME AS PROVISONER NAME VALUE IN STORAGECLASS
            - name: NFS_SERVER # do not change
              value: 192.168.1.7 # Ip of the NFS SERVER
            - name: NFS_PATH # do not change
              value: /srv/nfs/mydata2 # path to nfs directory setup
      volumes:
       - name: nfs-provisioner-v # same as volumemouts name
         nfs:
           server: 192.168.1.7
           path: /srv/nfs/mydata2
```

* Deploying the NFS client pod:

```
$ kubectl apply -f nfs_pod_provision.yaml
pod/nfs-pod-provisioner-66ffbbbbf-sg4kh   1/1     Running   0          7s
$ kubectl describe po nfs-pod-provisioner-66ffbbbbf-sg4kh
 nfs-provisioner-v:
    Type:      NFS (an NFS mount that lasts the lifetime of a pod)
    Server:    192.168.1.7
    Path:      /srv/nfs/mydata2
     Mounts:
      /persistentvolumes from nfs-provisioner-v (rw)

```

The NFS client has been attached to the NFS server and mounted to the persistence volume with Read and Write permission.

* Testing

Requesting a persistence volume claim and deploying it:

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs-pvc-test
spec:
  storageClassName: nfs-storageclass # SAME NAME AS THE STORAGECLASS
  accessModes:
    - ReadWriteMany #  must be the same as PersistentVolume
  resources:
    requests:
      storage: 50Mi

```

```
$ kubectl get pv,pvc
$ kubectl apply -f  nfs_pvc_dynamic.yaml
nfs-pvc-test   Bound    pvc-620ff5b1-b2df-11e9-a66a-080027db98ca   50Mi       RWX            nfs-storageclass   7s
$ ls /srv/nfs/mydata2/
default-nfs-pvc-test-pvc-620ff5b1-b2df-11e9-a66a-080027db98ca
```

You can see there is a default-nfs-pvc-test… folder that has been created inside mydata2/ folder. This is where all files that are created will be under.

Using an Nginx deployment to test:

vim nginx_nfs.yaml 

```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    app: nginx
  name: nfs-nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      volumes:
      - name: nfs-test #
        persistentVolumeClaim:
          claimName: nfs-pvc-test  # same name of pvc that was created
      containers:
      - image: nginx
        name: nginx
        volumeMounts:
        - name: nfs-test # name of volume should match claimName volume
          mountPath: mydata2 # mount inside of contianer
```

```
kubectl get pod
```

* Creating a text file inside the pod and verifying that it exists inside the mydata2/default-nfs-pvc….folder:

```
kubectl exec -it po nfs-nginx-76c48f6466-fnkh9 bash
cd mydata2/
root@nfs-nginx-76c48f6466-fnkh9:/mydata2# touch testfile.txt
exit
ls /srv/nfs/mydata2/default-nfs-pvc-test-pvc-620ff5b1-b2df-11e9-a66a-080027db98ca/
testfile.txt

```

