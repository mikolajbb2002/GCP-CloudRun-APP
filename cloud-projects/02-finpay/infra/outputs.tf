output "gke_cluster_name" {
  value = module.gke.cluster_name
}

output "gke_subnetwork" {
  value = module.network.subnet_01_id
}

output "sql_private_ip_address" {
  value = module.sql.private_ip_address
}

output "sql_connection_name" {
  value = module.sql.connection_name
}
