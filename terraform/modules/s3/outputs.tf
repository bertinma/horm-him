output "s3_bucket_arn" {
  value = aws_s3_bucket.this.arn
}
output "s3_bucket_name" {
  value = aws_s3_bucket.this.id
}

output "s3_bucket_url" {
  value = "http://${aws_s3_bucket.this.id}.s3-website-${var.aws_region}.amazonaws.com"
}