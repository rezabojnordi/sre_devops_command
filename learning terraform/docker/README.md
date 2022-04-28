## Create Terraform Infrastructure with Docker
In the "Code Editor" tab, open the main.tf file.

Copy and paste the following configuration. Save your changes by clicking on the icon next to the filename above the editor window.

```
mkdir learn-terraform-docker-container
```
```
cd learn-terraform-docker-container
```
```
touch main.tf
```


```
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.15.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "tutorial"
  ports {
    internal = 80
    external = 8000
  }
}
```

* In the "Terminal" tab, initialize the project, which downloads a plugin that allows Terraform to interact with Docker.

```
terraform init

```

Provision the NGINX server container with apply. When Terraform asks you to confirm, type yes and press ENTER

```
terraform validate
```
############################

```
terraform apply
```

## Verify NGINX instance
Run docker ps to view the NGINX container running in Docker via Terraform.

```
docker ps
```

Inspect the current state using terraform show.
```
terraform show
```


## Manually Managing State
Terraform has a built-in command called terraform state for advanced state management. Use the list subcommand to list of the resources in your project's state.


```
terraform state list
```



## Update configuration

Now update the external port number of your container. Change the docker_container.nginx resource under the provider block in main.tf by replacing the ports.external value of 8000 with 8080

```
resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "tutorial"
  hostname = "learn-terraform-docker"
  ports {
    internal = 80
-   external = 8000
+   external = 8080
  }
}
```

## Apply Changes
```
terraform apply
```

## Destroy resources
To stop the container and destroy the resources created in this tutorial, run terraform destroy. When Terraform asks you to confirm, type yes and press ENTER.

```
terraform destroy
```


## Set the container name with a variable

```
variable "container_name" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "ExampleNginxContainer"
}
```

Note: Terraform loads all files in the current directory ending in .tf, so you can name your configuration files however you choose.

In main.tf, update the docker_container resource block to use the new variable. The container_name variable block will default to its default value ("ExampleNginxContainer") unless you declare a different value.

```
resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
- name  = "tutorial"
+ name  = var.container_name
  ports {
    internal = 80
    external = 8080
  }
}
```
## Apply your configuration

```
terraform apply
```

Now apply the configuration again, this time overriding the default container name by passing in a variable using the -var flag. Terraform will update the container's name attribute with the new name. Respond to the confirmation prompt with yes.


```
terraform apply -var "container_name=YetAnotherName"
```

# all config

```
# main.tf

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = var.container_name
  ports {
    internal = 80
    external = 8080
  }
}
```
```
# variables.tf

variable "container_name" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "ExampleNginxContainer"
}
```


Ensure that your configuration matches this, and that you have initialized your configuration in the learn-terraform-docker-container directory.

```
terraform init
```

Apply the configuration before continuing this tutorial. Respond to the confirmation prompt with a yes.


```
terraform apply
```
‍‍‍

## Output Docker container configuration

Create a file called outputs.tf in your learn-terraform-docker-container directory.

Add the configuration below to outputs.tf to define outputs for your container's ID and the image ID.

```
output "container_id" {
  description = "ID of the Docker container"
  value       = docker_container.nginx.id
}

output "image_id" {
  description = "ID of the Docker image"
  value       = docker_image.nginx.id
}
```

## Inspect output values

```
terraform apply
```


Terraform prints output values to the screen when you apply your configuration. Query the outputs with the terraform output command.

```
terraform output
```
