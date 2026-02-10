terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket  = "self-healing-tf-state-eu"
    key     = "fragile/terraform.tfstate"
    region  = "eu-north-1"
    encrypt = true
  }
}
