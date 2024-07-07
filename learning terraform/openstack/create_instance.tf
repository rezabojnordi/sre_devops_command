# Configure the OpenStack Provider
terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}
 
 
# data "template_file" "user_data" {
#   template = file("add-user.yaml")
# }
variable "region" { default = "ap-au-1" }
# Create an Instance
resource "openstack_compute_instance_v2" "VM-Debian02" {
 
        name = "VM-Debian02"
        #Debian
        image_id = ""
        flavor_id = ""
        security_groups = ["Def_mrm"]
        # user_data       = data.template_file.user_data.rendered
        availability_zone = "nova"
        network {
            name = "public"
        }

}
