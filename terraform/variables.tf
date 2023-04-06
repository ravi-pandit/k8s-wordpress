variable "aws_region" {
  default = "ap-south-1"
}

variable "cluster-name" {
  default = "eks-demo"
  type    = string
}

variable "region" {
  default = "ap-south-1"
}

variable "project" {
  type    = string
  default = "laravelk8s"
}

variable "instance_class" {
  default = "db.t3.micro"
}

variable "username" {
  default = "admin"
}

variable "cidr" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets_cidr" {
  type    = list(any)
  default = ["10.0.128.0/24", "10.0.144.0/24", "10.0.160.0/24"]
}
variable "multi_az" {
  default = false
}

variable "ecr" {
 description = "Wordpress Docker Image"
 type = string
 default = "wordpress"
}