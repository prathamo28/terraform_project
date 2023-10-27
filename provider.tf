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
  alias  = "us-east-1"
  region = var.regions[0]
  access_key = "AKIA5TFR6JLPSZZ6ZVHQ"
  secret_key = "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"
}

provider "aws" {
  alias  = "us-east-2"
  region = var.regions[1]
  access_key = "AKIA5TFR6JLPSZZ6ZVHQ"
  secret_key = "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"
}

provider "aws" {
  alias  = "ap-southeast-1"
  region = var.regions[2]
  access_key = "AKIA5TFR6JLPSZZ6ZVHQ"
  secret_key = "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"
}

provider "aws" {
  alias  = "eu-west-1"
  region = var.regions[3]
  access_key = "AKIA5TFR6JLPSZZ6ZVHQ"
  secret_key = "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"
}