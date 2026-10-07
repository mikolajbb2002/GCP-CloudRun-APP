resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "subnet_01" {
  name                     = var.subnet_01_name
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.vpc_network.id
  ip_cidr_range            = var.subnet_01_cidr
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "subnet_02" {
  name                     = var.subnet_02_name
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.vpc_network.id
  ip_cidr_range            = var.subnet_02_cidr
  private_ip_google_access = true
}

resource "google_vpc_access_connector" "connector" {
  name          = var.vpc_connector_name
  ip_cidr_range = var.connector_cidr
  network       = google_compute_network.vpc_network.id
  min_instances = 2
  max_instances = 3
}

resource "google_compute_router" "this" {
  name    = var.router_name
  project = var.project_id
  region  = var.region
  network = google_compute_network.vpc_network.id
}

resource "google_compute_router_nat" "this" {
  name                               = var.nat_name
  project                            = var.project_id
  region                             = var.region
  router                             = google_compute_router.this.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}