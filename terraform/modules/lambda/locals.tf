locals {
  lambda_file_path = "${path.module}/scripts"
  panda_layer_arn = {
    eu-west-1 = "arn:aws:lambda:eu-west-1:336392948345:layer:AWSSDKPandas-Python310:2",
    eu-west-3 = "arn:aws:lambda:eu-west-3:336392948345:layer:AWSSDKPandas-Python310:2"
  }
}