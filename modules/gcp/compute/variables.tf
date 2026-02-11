variable "gcp_project_id" { type = string }
variable "gcp_region" { type = string }
variable "gcp_zone" { type = string }
variable "instance_name" { type = string }
variable "network_name" { type = string }
variable "subnet_name" { type = string }
variable "image_family" {
  type    = string
  default = "ubuntu-2204-lts"
}
variable "image_project" {
  type    = string
  default = "ubuntu-os-cloud"
}
