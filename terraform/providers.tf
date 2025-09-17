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
  access_key = "AKIA5JMSUE6W526XAV6N"
  secret_key = "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"
}
