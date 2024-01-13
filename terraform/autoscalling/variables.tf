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
