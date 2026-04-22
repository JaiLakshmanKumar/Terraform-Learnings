provider "azurerm" {
  
}

/*

You have a VM of size B1ls for team abc as they require dev instance.
Now they came and asked for pre-prod instance for VM size B1s

you think since you have module already you would create a dev.tfvars,pre-prod.tfvars.

current configuration changes from B1ls --> B1s

to address this we will use workspaces.
*/




variable "VM_Size" {
  description = "value"
  type = map(string)

  default = {
    "dev" = "Standard_B1ls"
    "stage" = "Standard_B1s"
    "prod" = "Standard_B1ms"
  }
}


module "azurevm" {
  source = "../workspaces/VM_Instance"

  my_ip = var.my_ip //left side # [Module Variable Name] = [Root Variable Value]
  admin_username = var.admin_username
  admin_password = var.admin_password
  
  VM_Size = lookup(var.VM_Size,terraform.workspace,"Standard_B1ls")

}