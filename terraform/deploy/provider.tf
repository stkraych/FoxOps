terraform {
  required_version = "1.6.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

    backend "s3" {
    bucket         	   = "state-bucket-9203143-4"
    key              	   = "terraform.tfstate"
    region         	   = "us-east-1"
    encrypt        	   = true
    dynamodb_table = "dynamo_table-3"
  }
}




