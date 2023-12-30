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
  access_key = "AKIAZ53P42NNNKP2QCM4"
  secret_key = "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"

}

# terraform {
#   backend "s3" {
#     bucket = "my-state-bucket"
#     key    = "terraform/state.tfstate"
#     region = "us-east-1"
#   }
# }

