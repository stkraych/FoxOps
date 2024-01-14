variable "DOCKERHUB_USERNAME" {
  description = "DockerHub username"
  type = string
}

variable "DOCKERHUB_PASSWORD" {
  description = "DockerHub password"
  type = string
}


variable "DOCKERHUB_REPO" {
  description = "DockerHub repo"
  type = string
}


variable "TAG" {
  description = "Image tag"
  type = string
}

variable "BUCKET_NAME" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
}

variable "TABLE_NAME" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
}

