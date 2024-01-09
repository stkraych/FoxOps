terraform {
  required_version = "1.6.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

    backend "s3" {
    bucket         	   = "my-bucket-1234d"
    key              	   = "state/terraform.tfstate"
    region         	   = "us-east-1"
    encrypt        	   = true
    dynamodb_table = "my_dynamo"
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "example-bucket-1239y37-cat"
}



