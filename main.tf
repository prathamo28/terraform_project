# KMS Key for Vault
resource "aws_kms_key" "backup_key" {
  description = "Backup key for vault"
  key_usage = "ENCRYPT_DECRYPT"
}

# Vault for thirty-day retention
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








