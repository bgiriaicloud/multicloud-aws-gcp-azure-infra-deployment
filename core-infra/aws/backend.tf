terraform {
  backend "s3" {
    bucket         = "multi-cloud-aws-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
