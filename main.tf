data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "alt_vault_role" {
  name               = "example"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "example" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.alt_vault_role.name
}



# KMS Key for Vault
resource "aws_kms_key" "backup_key" {
  description = "Backup key for vault"
  key_usage = "ENCRYPT_DECRYPT"
}

# Vault for thirty-day retention new
resource "aws_backup_vault" "thirty_day_retention_vault" {
  name                 = "alt-vault-thirty-day-retention-v1"
  kms_key_arn          = aws_kms_key.backup_key.arn
}

resource "aws_backup_plan" "thirty_day_retention_plan" {
  name = "example_backup_plan"
  rule {
    rule_name = "example_backup_rule"
    target_vault_name = aws_backup_vault.thirty_day_retention_vault.name
    schedule = "cron(0 5 * * ? *)"
    
    lifecycle {
      delete_after = 2
    }
  }
}

resource "aws_backup_selection" "ec2_selection" {
  iam_role_arn = aws_iam_role.alt_vault_role.arn
  name = "backup-selection"
  plan_id = aws_backup_plan.thirty_day_retention_plan.id
  resources = ["arn:aws:ec2:*:*:instance/*"]
  }









