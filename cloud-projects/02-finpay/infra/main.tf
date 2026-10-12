data "google_client_config" "current" {}

module "network" {
  source              = "./modules/network"
  project_id          = data.google_client_config.current.project
  region              = var.region
  vpc_name            = var.vpc_name
  subnet_01_name      = var.subnet_01_name
  subnet_01_cidr      = var.subnet_01_cidr
  subnet_02_name      = var.subnet_02_name
  subnet_02_cidr      = var.subnet_02_cidr
  pods_cidr_range     = var.pods_cidr_range
  services_cidr_range = var.services_cidr_range
  vpc_connector_name  = var.vpc_connector_name
  connector_cidr      = var.connector_cidr
  router_name         = var.router_name
  nat_name            = var.nat_name
}

module "gke" {
  source       = "./modules/gke"
  project_id   = data.google_client_config.current.project
  region       = var.region
  cluster_name = var.cluster_name
  network_id   = module.network.network_id
  subnet_id    = module.network.subnet_01_id
  secret_id    = var.secret_id
  account_id   = var.account_id
}

module "sql" {
  source = "./modules/sql"
  # This output depends on the PSA connection being ready.
  network_id = module.network.private_network_id
  region     = var.region
}
