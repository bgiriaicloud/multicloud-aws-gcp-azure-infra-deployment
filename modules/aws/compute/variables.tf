variable "ami_id" { type = string }
variable "instance_type" { default = "t3.micro" }
variable "ec2_sg_id" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "target_group_arn" { type = string }
