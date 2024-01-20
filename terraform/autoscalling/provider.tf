terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

    backend "s3" {
    bucket         	   = "autoscalling-bucket-23482-1"
    key              	   = "terraform.tfstate"
    region         	   = "us-east-1"
    encrypt        	   = true
    dynamodb_table = "autoscalling-dynamo-db"
  }
}

provider "aws" {
  region = "us-east-1"
}
