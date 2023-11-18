terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.25.0"
    }
  }
  backend "s3" {
    bucket = "Kandidat2017"
    key    = "terraform/apprunner.state"
    region = "eu-west-1"
  }
}