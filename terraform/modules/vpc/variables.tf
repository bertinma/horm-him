variable "default_tags" {
  type = map(any)
}

variable "vpc_cidr_block" {
  type = string
}

variable "aws_availability_zone_names" {
  type = list(string)
}