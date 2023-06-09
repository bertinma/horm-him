variable "vpc" {
  type = map(any)
  default = {
    name = "horm_him_vpc"
    vpc_cidr_block = "172.29.0.0/16"
  }
}

variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "default_tags" {
  type = map(any)
  default = {
    environment = "tf"
  }
}

variable "bucket_name" {
  type = string
  default = "form-him-bucket"
}

variable "csv_file_name" {
  type    = string
  default = "orders.csv"
}
