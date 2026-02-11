variable "aws_region" { default = "us-east-1" }
variable "aws_ami_id" { default = "ami-0c55b159cbfafe1f0" }
variable "aws_alb_sg_id" { type = string }
variable "aws_ec2_sg_id" { type = string }
variable "aws_db_sg_id" { type = string }
variable "ssh_public_key" { type = string }
variable "db_password" { type = string }
variable "domain_name" { 
  type    = string
  default = "example.com"
}
