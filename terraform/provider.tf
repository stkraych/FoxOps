terraform {
  required_version = "1.6.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""

}

# terraform {
#   backend "s3" {
#     bucket = "my-state-bucket"
#     key    = "terraform/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

