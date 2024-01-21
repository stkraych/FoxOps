variable "subnet_type" {
  default = {
    public  = "public"
    private = "private"
  }
}
variable "cidr_ranges" {
  
  default = {
    publicA  = "172.16.1.0/24"
    publicB  = "172.16.2.0/24"
    privateA = "172.16.3.0/24"
    privateB = "172.16.4.0/24"
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

