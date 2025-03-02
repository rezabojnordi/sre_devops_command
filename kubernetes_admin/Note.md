Note:
* Reasoned about resource requests and limits for a couple of seconds
Requests specify the minimum resources guaranteed to a container, while limits cap the maximum resources it can use.

```bash
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-resources
  namespace: dev
spec:
  hard:
    requests.cpu: "2"       # Total CPU requests allowed (e.g., 2 cores)
    limits.cpu: "4"         # Total CPU limits allowed (e.g., 4 cores)
    requests.memory: "4Gi"  # Total memory requests allowed (e.g., 4GiB)
    limits.memory: "8Gi"    # Total memory limits allowed (e.g., 8GiB)

```