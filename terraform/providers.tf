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
  access_key = ""AKIA5JMSUE6WV6Y5XT4J
  secret_key = "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"
}
