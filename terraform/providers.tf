terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket  = "babs-sandbox-terraform-state"
    key     = "sandbox-terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}
