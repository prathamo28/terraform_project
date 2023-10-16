terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "AKIA5TFR6JLPSZZ6ZVHQ"
  secret_key = "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"
}