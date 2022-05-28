
```
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt-get update && sudo apt-get install terraform

```
```
terraform -help
```
```
touch ~/.bashrc

terraform -install-autocomplete

```




# concept



<img src="image/t1.png" width="800" height="500" />
<img src="image/t2.png" width="800" height="500" />
<img src="image/t3_declarative.png" width="800" height="500" />
<img src="image/t4_idempotent&Consistency.png" width="800" height="500" />

<img src="image/t4_push_pull.png" width="800" height="500" />
<img src="image/t5_benefit.png" width="800" height="500" />
<img src="image/t6_automation.png" width="800" height="500" />

<img src="image/t7_component.png" width="800" height="500" />
<img src="image/t8_variable.png" width="800" height="500" />

<img src="image/t9_data.png" width="800" height="500" />
<img src="image/t9_provider.png" width="800" height="500" />
<img src="image/t10_resource.png" width="800" height="500" />

<img src="image/t11_state.png" width="800" height="500" />
<img src="image/t12_planning.png" width="800" height="500" />
<img src="image/t13_additional_resources.png" width="800" height="500" />

<img src="image/t15_agenda.png" width="800" height="500" />
<img src="image/t16_block_terraform.png" width="800" height="500" />
<img src="image/t17_object_type.png" width="800" height="500" />
<img src="image/t18_object_type.png" width="800" height="500" />

<img src="image/t19_object_type_refrence.png" width="800" height="500" />
<img src="image/t20_provisioners.png" width="800" height="500" />
<img src="image/t21_function.png" width="800" height="500" />

<img src="image/t22_function_categories.png" width="800" height="500" />
<img src="image/t23_provisioner_file.png" width="800" height="500" />
<img src="image/t24_provider_digitalocceon.png" width="800" height="500" />

<img src="image/t25_terrafform_string.png" width="800" height="500" />
<img src="image/t26_terrafor_console_network.png" width="800" height="500" />

<img src="image/t27_terraform_console.png" width="800" height="500" />
<img src="image/t28_terraform_digitalocceion.png" width="800" height="500" />
<img src="image/t29_terraform_digitalocceion.png" width="800" height="500" />
<img src="image/t30_digital_occion.png" width="800" height="500" />

<img src="image/t31_digitaloccion.png" width="800" height="500" />


## openstack 

<img src="image/confe1.png" width="800" height="500" />
<img src="image/confe2.png" width="800" height="500" />
<img src="image/confe3.png" width="800" height="500" />

<img src="image/confe4.png" width="800" height="500" />
<img src="image/confe5_plan" width="800" height="500" />
<img src="image/confe7_provisioning.png" width="800" height="500" />
<img src="image/confe8_provisiing.png" width="800" height="500" />
<img src="image/confe9_provisiing.png" width="800" height="500" />
<img src="image/confe10_provisiing_local_exec.png" width="800" height="500" />