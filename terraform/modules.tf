module "vpc" {
  source = "./modules/vpc"

  aws_availability_zone_names = data.aws_availability_zones.available.names
  vpc_cidr_block              = local.vpc_cidr_block

  default_tags = var.default_tags
}

module "s3" {
  source = "./modules/s3"

  bucket_name   = var.bucket_name

  default_tags = var.default_tags
}

module "lambda" {
  depends_on          = [module.vpc.public_subnet_ids]
  source              = "./modules/lambda"
  lambda_zip_filename = "lambda_function_payload.zip"
  python_runtime      = "python3.10"
}

