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

variable "ami" {
  description = "Ami of aws ssm"
  type = string
  default = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
