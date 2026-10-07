data "google_client_config" "current" {}

module "registry" {
  source                    = "./modules/registry"
  region                    = var.region
  registry_repo_id          = var.registry_repo_id
  registry_repo_description = var.registry_repo_description
}

module "network" {
  source             = "./modules/network"
  project_id         = data.google_client_config.current.project
  region             = var.region
  vpc_name           = var.vpc_name
  subnet_01_name     = var.subnet_01_name
  subnet_01_cidr     = var.subnet_01_cidr
  subnet_02_name     = var.subnet_02_name
  subnet_02_cidr     = var.subnet_02_cidr
  vpc_connector_name = var.vpc_connector_name
  connector_cidr     = var.connector_cidr
  router_name        = var.router_name
  nat_name           = var.nat_name
}

module "app" {
  source             = "./modules/app"
  project_id         = data.google_client_config.current.project
  region             = var.region
  cloud_service_name = var.cloud_service_name
  image              = var.image
  vpc_connector_id   = module.network.vpc_connector_id
}
