# VPC Module
module "vpc" {
  source = "../../modules/aws/vpc"

  vpc_cidr              = "10.0.0.0/16"
  public_subnet_cidr    = "10.0.1.0/24"
  private_compute_cidr  = ["10.0.10.0/24", "10.0.11.0/24"]
  private_db_cidr       = ["10.0.20.0/24", "10.0.21.0/24"]
  az1                   = "${var.aws_region}a"
  az2                   = "${var.aws_region}b"
}

# Load Balancer Module
module "load_balancer" {
  source = "../../modules/aws/load_balancer"

  vpc_id           = module.vpc.vpc_id
  alb_sg_id        = var.aws_alb_sg_id
  public_subnet_id = module.vpc.public_subnet_id
}

# Compute Module (Auto Scaling Group)
module "compute" {
  source = "../../modules/aws/compute"

  ami_id             = var.aws_ami_id
  instance_type      = "t3.micro"
  ec2_sg_id          = var.aws_ec2_sg_id
  private_subnet_ids = module.vpc.private_compute_subnet_ids
  target_group_arn   = module.load_balancer.target_group_arn
}

# Database Module (RDS Multi-AZ)
module "database" {
  source = "../../modules/aws/database"

  database_subnet_ids = module.vpc.private_db_subnet_ids
  db_sg_id            = var.aws_db_sg_id
  db_password         = var.db_password
}

# Edge Module (CloudFront + Route 53)
module "edge" {
  source = "../../modules/aws/edge"

  alb_dns_name = module.load_balancer.alb_dns_name
  domain_name  = var.domain_name
}
