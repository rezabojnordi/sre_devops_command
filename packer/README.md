
# how to use packer
```bash
packer init .
packer plugins install github.com/hashicorp/googlecompute
packer build -var-file=variables.pkvars.hcl ./
```
