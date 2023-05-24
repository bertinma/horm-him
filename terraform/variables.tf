variable "vpc" {
  type = map(any)
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
}

variable "csv_file_name" {
  type    = string
  default = "orders.csv"
}
