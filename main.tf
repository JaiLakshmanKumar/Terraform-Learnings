provider "azurerm" {
  
}


module "azurevm" {
  source = "./modules/VM_Instance"
  admin_username = "jai_user"
  admin_password = "Jai123@"
}