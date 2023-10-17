#Creating KMS key 
resource "aws_kms_key" "alt_backup_day_key" {
  description = "Alt-Backup-key-day-vault"
}

#Creating AWS Vault policy 
data "aws_iam_policy_document" "alt_backup_vault_policy" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["backup:CopyIntoBackupVault",
                 "backup:CopyFromBackupVault",
                 "backup:CopyIntoBackupVault",
                 "backup:CreateReportPlan",
                 "backup:DescribeBackupJob",
                 "backup:DescribeBackupVault",
                 "backup:DescribeCopyJob",
                 "backup:DescribeFramework",
                 "backup:DescribeProtectedResource",
                 "backup:DescribeRecoveryPoint",
                 "backup:DescribeReportJob",
                 "backup:DescribeReportPlan",
                 "backup:DescribeRestoreJob",
                 "backup:ListBackupJobs",
                 "backup:ListBackupPlans",
                 "backup:ListBackupVaults",
                 "backup:ListCopyJobs",
                 "backup:StartBackupJob",
                 "backup:StartCopyJob",
                 "backup:StartReportJob",
                 "backup:StartRestoreJob",
                 "backup:StopBackupJob"]

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "aws:PrincipalOrgPaths"
      values   = ["o-1llr6jd9b2/r-[RootID]/ou-[OU]/*"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_backup_vault" "alt_backup_day_vault" {
  name        = "alt-vault-twenty-day-retention-v1"
  kms_key_arn = aws_kms_key.alt_backup_day_key.arn
}

resource "aws_backup_vault_policy" "alt_backup_day_vault_policy" {
  backup_vault_name = aws_backup_vault.alt_backup_day_vault.name
  policy            = data.aws_iam_policy_document.alt_backup_vault_policy.json
}

resource "aws_backup_plan" "alt_backup_day_plan" {
  name = "alt-backup-day-plan"
  rule {
    rule_name = "alt-vault-twenty-day-plan"
    target_vault_name = aws_backup_vault.alt_backup_day_vault.name
    schedule = "cron(30 5 * * ? *)"
  }
  lifecycle {
    delete_after = 2
  }
  advanced_backup_setting {
    backup_options = {
        WindowsVSS = "enabled"
    }
    resource_type = ["EC2"]
  }
}


