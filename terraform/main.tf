

module "vpc" {
  source              = "git@github.com:cmonthe2/terraform-module.git//modules/vpc?ref=vpc/1.0.0"
  project_name        = "tier-3-project"
  environment         = "dev"
  vpc_cidr            = "10.0.0.0/16"
  availability_zones  = ["us-east-1a", "us-east-1b"]
  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_app_subnets = ["10.0.10.0/24", "10.0.11.0/24"]
  private_db_subnets  = ["10.0.20.0/24", "10.0.21.0/24"]
}


module "security" {
  source = "git@github.com:cmonthe2/terraform-module.git//modules/security?ref=security/1.0.0"

  project_name = "tier-3-project"
  environment  = "dev"
  vpc_id       = module.vpc.vpc_id

}

module "waf" {
  source = "git@github.com:cmonthe2/terraform-module.git//modules/waf?ref=waf/1.0.0"

  project_name      = "tier-3-project"
  environment       = "dev"
  alb_arn           = module.compute.alb_arn
  rate_limit_per_ip = 1000
}
module "compute" {
  source = "git@github.com:cmonthe2/terraform-module.git//modules/compute?ref=compute/1.0.0"

  project_name           = "tier-3-project"
  environment            = "dev"
  vpc_id                 = module.vpc.vpc_id
  public_subnet_ids      = module.vpc.public_subnet_ids
  private_app_subnet_ids = module.vpc.private_app_subnet_ids
  alb_sg_id              = module.security.alb_sg_id
  app_sg_id              = module.security.app_sg_id
  instance_type          = "t3.micro"
  asg_min_size           = 1
  asg_max_size           = 4
  asg_desired_capacity   = 2
}

module "database" {
  source                = "git@github.com:cmonthe2/terraform-module.git//modules/database?ref=database/1.0.2"
  project_name          = "tier-3-project"
  environment           = "dev"
  private_db_subnet_ids = module.vpc.private_db_subnet_ids
  db_sg_id              = module.security.db_sg_id
  db_name               = "appdb"
  db_username           = "admin"
  db_password           = true
  db_instance_class     = "db.t3.micro"
  db_allocated_storage  = 20
}

module "monitoring" {
  source                  = "git@github.com:cmonthe2/terraform-module.git//modules/monitoring?ref=monitoring/1.0.0"
  project_name            = "tier-3-project"
  environment             = "dev"
  vpc_id                  = module.vpc.vpc_id
  flow_log_retention_days = 14

}


output "vpc_id" { value = module.vpc.vpc_id }
output "alb_dns_name" { value = module.compute.alb_dns_name }
output "rds_endpoint" { value = module.database.rds_endpoint }

