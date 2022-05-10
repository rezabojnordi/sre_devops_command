# Configure the OpenStack Provider
terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}
 
 
data "template_file" "user_data" {
  template = file("data.yml")
}
variable "region" { default = "ap-au-1" }
variable network {
    default = "public"
}

variable network2 {
    default = "public2"
}



variable image_id {
    default = ""
}

variable flavor_id {
    default = ""
}
# Create an Instance
resource "openstack_compute_instance_v2" "VM-Debian02" {
 
        name = "VM-Debi"
        #Debian
        image_id = var.image_id
        #image_name = var.image_name
        flavor_id = var.flavor_id
        security_groups = ["Def_mrm"]
        user_data       = data.template_file.user_data.rendered
        availability_zone = "nova"
        network {
            name = var.network
        }

    connection {
        user = "debian"
        password = "reza@123"
        host = "${self.access_ip_v4}"
    }
    #   network {
        #     name =  var.network2
        # }
    provisioner "local-exec" {

           #command = "echo ${self.access_ip_v4} ${self.name} >> /etc/hosts; mkdir rr"
           command = "mkdir ~/rr"
        }



}



# resource "openstack_blockstorage_volume_v2" "volume_new" {
#   name = "volume_new"
#   size = 2
#   description = "first test volume"
# }

# resource "openstack_compute_volume_attach_v2" "va_1"{
#     instance_id = "${openstack_compute_instance_v2.VM-Debian02.id}"
#     volume_id   = "${openstack_blockstorage_volume_v2.volume_new.id}"
# }
