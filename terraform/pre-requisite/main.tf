
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.BUCKET_NAME
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "versioning_S3" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "S3_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}


resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.TABLE_NAME
  hash_key     = "LockID"
  read_capacity  = 10
  write_capacity = 10

  attribute {
    name = "LockID"
    type = "S"
  }
}
