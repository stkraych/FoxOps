variable "subnet_type" {
  default = {
    public  = "public"
    private = "private"
  }
}
variable "cidr_ranges" {
  default = {
    publicA  = "10.0.1.0/24"
    publicB  = "10.0.2.0/24"
    privateA = "10.0.3.0/24"
    privateB = "10.0.4.0/24"
  }
}
variable "used_image" {
  default = "ami-0005e0cfe09cc9050"
  }


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
