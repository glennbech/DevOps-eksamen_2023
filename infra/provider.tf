terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.25.0"
    }
  }
  backend "s3" {
    bucket = "Kandidat2017"
    key    = "Kandidat2017/apprunner.state"
    region = "eu-west-1"
  }
}