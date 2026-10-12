# Reserve a non-overlapping range after the VPC subnet ranges exist.
resource "google_compute_global_address" "psa" {
  project       = var.project_id
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20
  network       = google_compute_network.vpc_network.id

  depends_on = [
    google_compute_subnetwork.subnet_01,
    google_compute_subnetwork.subnet_02,
    google_vpc_access_connector.connector,
  ]
}

# Connect this VPC to the Google-managed service producer network.
resource "google_service_networking_connection" "psa" {
  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.psa.name]
}
