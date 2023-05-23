resource "aws_iam_role" "lambda_role" {
  name = "vaultwarden_lambda_role"

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
    name = "vaultwarden_lambda_policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "ecs:RunTask",
            "ecs:ListTasks",
            "ecs:DescribeTasks",
            "ecs:StopTask",
            "ecs:"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "ec2:DescribeNetworkInterfaces"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
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
  function_name = "vaultwarden_lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_.lambda_handler"
  timeout       = 60

  runtime = var.python_runtime
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