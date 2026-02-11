module "vpc" {
  source = "../../modules/gcp/vpc"

  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
}

module "compute" {
  source = "../../modules/gcp/compute"

  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone
  instance_name  = "web-server"
  network_name   = module.vpc.network_name
  subnet_name    = module.vpc.private_compute_subnet_name
}

module "database" {
  source = "../../modules/gcp/database"

  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  network_id     = module.vpc.network_id
  db_password    = var.db_password
}

module "load_balancer" {
  source = "../../modules/gcp/load_balancer"

  project_id         = var.gcp_project_id
  mig_instance_group = module.compute.mig_self_link
  domain_name        = "example.com"
}
