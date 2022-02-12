kubectl create -f rs.yml
kubectl get replicasets
# How to update?
kubectl replace -f rs.yml
kubectl scale --replicas=6 -f rs.yml
kubectl scale --replicas=6 replicaset nginx-rs



