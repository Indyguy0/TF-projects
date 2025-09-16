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
  access_key = "AKIA5JMSUE6WTJIURW4Q"
  secret_key = "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"
}
