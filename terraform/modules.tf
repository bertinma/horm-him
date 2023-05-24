module "vpc" {
  source = "./modules/vpc"

  aws_availability_zone_names = data.aws_availability_zones.available.names
  vpc_cidr_block              = local.vpc_cidr_block

  default_tags = var.default_tags
}

module "s3" {
  source = "./modules/s3"

  bucket_name     = var.bucket_name
  aws_region      = var.aws_region
  lambda_role_arn = module.lambda.lambda_role_arn
  csv_file_name   = var.csv_file_name

  default_tags = var.default_tags
}

module "lambda" {
  depends_on          = [module.vpc.public_subnet_ids, module.s3.s3_bucket_arn]
  source              = "./modules/lambda"
  lambda_zip_filename = "lambda_function_payload.zip"
  python_runtime      = "python3.10"
  s3_bucket_arn       = module.s3.s3_bucket_arn
  aws_region          = var.aws_region
  csv_file_name       = var.csv_file_name
  s3_bucket_name      = module.s3.s3_bucket_name
}

