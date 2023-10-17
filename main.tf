#Creating KMS key 
resource "aws_kms_key" "alt_backup_day_key" {
  description = "Alt-Backup-key-day-vault"
}

resource "aws_backup_vault" "alt_backup_day_vault" {
  name        = "alt-vault-twenty-day-retention-v1"
  kms_key_arn = aws_kms_key.alt_backup_day_key.arn
}

resource "aws_backup_vault_lock_configuration" "alt_backup_day_lock" {
  backup_vault_name   = "alt-vault-twenty-day-retention-v1"
  max_retention_days  = 7
  min_retention_days  = 7
}

