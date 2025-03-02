terraform {
  required_version = ">= 1.5.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "temperature_survey" {
  bucket = var.bucket_name
}

resource "aws_s3_object" "tokyo_analytics" {
  bucket = aws_s3_bucket.temperature_survey.id
  key = var.bucket_object_tokyo
  source = var.bucket_object_tokyo
  content_type = "csv"
}

resource "aws_s3_object" "sapporo_analytics" {
  bucket = aws_s3_bucket.temperature_survey.id
  key = var.bucket_object_sapporo
  source = var.bucket_object_sapporo
  content_type = "csv"
}

resource "aws_iam_role" "sagemaker_role" {
  name = "SageMakerNotebookRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3AccessPolicy"
  description = "Policy to allow access to the S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          aws_s3_bucket.temperature_survey.arn,
          "${aws_s3_bucket.temperature_survey.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_sagemaker_notebook_instance" "notebook" {
  name                 = var.notebook_instance_name
  instance_type        = "ml.t3.medium"
  platform_identifier = "notebook-al2-v3"
  role_arn             = aws_iam_role.sagemaker_role.arn
  lifecycle_config_name = null
  tags = {
    Environment = "Terraform"
  }
}
