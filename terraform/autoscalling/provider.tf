terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }

    backend "s3" {
    bucket         	   = "autoscalling-bucket-23482-22"
    key              	   = "autoscalling/terraform.tfstate"
    region         	   = "us-east-1"
    encrypt        	   = true
    dynamodb_table = "autoscalling-dynamo-db"
  }
}
