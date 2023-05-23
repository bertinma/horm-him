resource "aws_flow_log" "this" {
  iam_role_arn    = aws_iam_role.this.arn
  log_destination = aws_cloudwatch_log_group.this.arn
  traffic_type    = "ALL"
  vpc_id          = module.vpc.vpc_id

  tags = var.default_tags
}

resource "aws_cloudwatch_log_group" "this" {
  name         = "/labs/01_static_site_hosting_vpc_flow_log"
  skip_destroy = false
  provisioner "local-exec" {
    when    = destroy
    command = "aws logs delete-log-group --log-group-name ${self.name}"

  }

  tags = var.default_tags
}


resource "aws_iam_role" "this" {
  name               = "01_static_site_hosting_vpc_flow_log_iam_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.default_tags
}

resource "aws_iam_role_policy" "this" {
  name   = "01_static_site_hosting_vpc_flow_log_iam_role_policy"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.this.json
}