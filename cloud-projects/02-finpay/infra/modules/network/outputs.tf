output "network_id" {
  value = google_compute_network.vpc_network.id
}

output "subnet_01_id" {
  value = google_compute_subnetwork.subnet_01.id
}

output "vpc_connector_id" {
  value = google_vpc_access_connector.connector.id
}

output "private_network_id" {
  value = google_service_networking_connection.psa.network
}