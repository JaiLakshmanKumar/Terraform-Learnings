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
  admin_username = "jai_user"
  admin_password = "Jai123@"
  VM_Size = lookup(var.VM_Size,terraform.workspace,"Standard_B1ls")

}