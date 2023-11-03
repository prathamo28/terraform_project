data "aws_instance" "alt_ec2_role_data" {
 instance_tags = {
    backup = "yes"
 }
}

data "aws_iam_instance_profile" "alt_ec2_role_name" {
  name = data.aws_instance.alt_ec2_role_data.iam_instance_profile
}

data "aws_iam_role" "ec2_instance_role" {
 name   = data.aws_iam_instance_profile.alt_ec2_role_name.role
}

output "role_name" {
  value = data.aws_iam_role.ec2_instance_role.arn
}

resource "aws_kms_key" "bucket_key" {
 description             = "KMS key for s3 buckets"

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

