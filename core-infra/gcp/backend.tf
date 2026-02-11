terraform {
  backend "gcs" {
    bucket  = "multi-cloud-gcp-state-bucket"
    prefix  = "terraform/state"
  }
}
