data "aws_instance" "alt_ec2_role_data" {
 filter {
    name   = "alt:platform"
    values = ["boardex"]
 }
}

data "aws_iam_instance_profile" "alt_ec2_role_name" {
  name = data.aws_instance.alt_ec2_role_data.iam_instance_profile
}

data "aws_iam_role" "ec2_instance_role" {
 name = data.aws_iam_instance_profile.alt_ec2_role_name.role_arn
}

output "role_name" {
  value = data.aws_iam_role.ec2_instance_role.arn
}

resource "aws_kms_key" "bucket_key" {
 description             = "KMS key for s3 buckets"
 deletion_window_in_days = 10

 policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEC2InstanceRoleEncrypt"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_iam_role.ec2_instance_role.arn
        }
        Action = "kms:Encrypt"
        Resource = "*"
      }
    ]
 })
}

resource "aws_s3_bucket" "test_database_backup" {
 bucket = "alt-s3-database-backup-${data.aws_caller_identity.current.account_id}-test-v1"
 acl    = "private"

 server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
 }

 policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${aws_s3_bucket.test_database_backup.bucket}/*"
        Principal = {
          AWS = data.aws_iam_role.ec2_instance_role.arn
        }
      }
    ]
 })
}

resource "aws_s3_bucket" "prod_database_backup" {
 bucket = "alt-s3-database-backup-${data.aws_caller_identity.current.account_id}-prod-v1"
 acl    = "private"

 server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
 }

 policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${aws_s3_bucket.prod_database_backup.bucket}/*"
        Principal = {
          AWS = data.aws_iam_role.ec2_instance_role.arn
        }
      }
    ]
 })
}

resource "aws_s3_bucket" "test_app_backup" {
 bucket = "alt-s3-app-backup-${data.aws_caller_identity.current.account_id}-test-v1"
 acl    = "private"

 server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
 }

 policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${aws_s3_bucket.test_app_backup.bucket}/*"
        Principal = {
          AWS = data.aws_iam_role.ec2_instance_role.arn
        }
      }
    ]
 })
}

resource "aws_s3_bucket" "prod_app_backup" {
 bucket = "alt-s3-app-backup-${data.aws_caller_identity.current.account_id}-prod-v1"
 acl    = "private"

 server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
 }

 policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${aws_s3_bucket.prod_app_backup.bucket}/*"
        Principal = {
          AWS = data.aws_iam_role.ec2_instance_role.arn
        }
      }
    ]
 })
}