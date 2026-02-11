resource "google_compute_global_address" "private_ip_address" {
  provider       = google-beta
  name           = "cloud-sql-private-ip-range"
  purpose        = "VPC_PEERING"
  address_type   = "INTERNAL"
  prefix_length  = 16
  network        = var.network_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider                = google-beta
  network                 = var.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "master" {
  name             = "private-instance-${random_id.db_name_suffix.hex}"
  region           = var.gcp_region
  database_version = var.db_version

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    availability_type = "REGIONAL" # High Availability (HA) Multi-Zone

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }
  }
}

resource "google_sql_user" "users" {
  name     = "dbadmin"
  instance = google_sql_database_instance.master.name
  password = var.db_password
}
