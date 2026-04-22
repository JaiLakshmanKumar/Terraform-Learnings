variable "admin_username" {
  type      = string
  sensitive = true
}

variable "admin_password" {
  type      = string
  sensitive = true
}
variable "my_ip" {
  type        = string
  description = "My local public IP address for SSH access"
}