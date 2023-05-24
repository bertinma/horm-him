variable "default_tags" {
  type = map(any)
}

variable "bucket_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "lambda_role_arn" {
  type = string
}

variable "csv_file_name" {
  type = string
}