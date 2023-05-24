resource "aws_iam_role" "lambda_role" {
  name = "horm_him_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name = "horm_him_lambda_policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:*"
          ]
          Effect = "Allow"
          Resource = [
            "${var.s3_bucket_arn}/*",
            "${var.s3_bucket_arn}"
          ]
        },
        {
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Effect = "Allow"
          Resource = "arn:aws:logs:*:*:*"
        }
      ]
    })
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}


data "archive_file" "zip_code" {
  type        = "zip"
  source_dir  = "${local.lambda_file_path}/"
  output_path = "${path.module}/${var.lambda_zip_filename}"

}

resource "aws_lambda_function" "this" {
  depends_on    = [aws_iam_role.lambda_role, data.archive_file.zip_code]
  filename      = "${path.module}/${var.lambda_zip_filename}"
  function_name = "horm_him_lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_.lambda_handler"
  timeout       = 60
  layers = [
    local.panda_layer_arn[var.aws_region]
  ]

  runtime = var.python_runtime

  environment {
    variables = {
      BUCKET_NAME = var.s3_bucket_name
      FILE_NAME   = var.csv_file_name
    }
  }

}

resource "null_resource" "this" {
  triggers = {
    lambda_zip_filename = var.lambda_zip_filename
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "rm -rf ${path.module}/${self.triggers.lambda_zip_filename}"
    on_failure = continue
  }
}

resource "aws_lambda_function_url" "this" {
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["*"]
    max_age           = 86400
  }
}