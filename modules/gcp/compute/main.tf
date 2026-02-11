resource "google_compute_health_check" "autohealing" {
  name                = "${var.instance_name}-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/"
    port         = "80"
  }
}

resource "google_compute_instance_template" "compute_template" {
  name_prefix  = "${var.instance_name}-template-"
  machine_type = "e2-medium"
  region       = var.gcp_region

  tags = ["allow-health-check", "allow-ssh"]

  disk {
    source_image = "${var.image_project}/${var.image_family}"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_name
    
    # No access config means no external IP -> Private Subnet
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "mig" {
  name = "${var.instance_name}-mig"

  base_instance_name         = var.instance_name
  target_size                = 2
  distribution_policy_zones  = ["${var.gcp_region}-a", "${var.gcp_region}-b"]

  version {
    instance_template = google_compute_instance_template.compute_template.id
  }

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 300
  }
}
