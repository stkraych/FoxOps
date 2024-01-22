terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }

    backend "s3" {
    bucket         	   = "state-bucket-9203143-15"
    key              	   = "deploy/terraform.tfstate"
    region         	   = "us-east-1"
    encrypt        	   = true
    dynamodb_table = "dynamo_table-3"
  }
}




