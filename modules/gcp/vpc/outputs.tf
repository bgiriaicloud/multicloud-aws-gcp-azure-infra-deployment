output "network_id" {
  value = google_compute_network.main.id
}

output "network_name" {
  value = google_compute_network.main.name
}

output "private_compute_subnet_id" {
  value = google_compute_subnetwork.private_compute.id
}

output "private_compute_subnet_name" {
  value = google_compute_subnetwork.private_compute.name
}

output "private_db_subnet_id" {
  value = google_compute_subnetwork.private_db.id
}
