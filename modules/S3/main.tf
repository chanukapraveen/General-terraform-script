resource "aws_s3_bucket" "example" {
  bucket = var.bucket

  tags = {
    Name        = var.name
    Environment = var.Environment
  }
}
