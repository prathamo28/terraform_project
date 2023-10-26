# KMS Key for Vault
resource "aws_kms_key" "backup_key" {
  description = "Backup key for ${aws_organization.id}"
  key_usage = "ENCRYPT_DECRYPT"
}


# Vault for thirty-day retention
resource "aws_backup_vault" "thirty_day_retention_vault" {
  name                 = "alt-vault-thirty-day-retention-v1"
  kms_key_arn          = aws_kms_key.backup_key.arn
}
resource "aws_backup_vault_lock_configuration" "alt_backup_thirty_day_lock" {
  backup_vault_name   = "alt-vault-thirty-day-retention-v1"
  max_retention_days  = 7
  min_retention_days  = 30
}


resource "aws_backup_vault" "six_month_retention_vault" {
  name                 = "alt-vault-six-month-retention-v1"
  kms_key_arn          = aws_kms_key.backup_key.arn
}
resource "aws_backup_vault_lock_configuration" "alt_backup_six_month_lock" {
  backup_vault_name   = "alt-vault-six-month-retention-v1"
  max_retention_days  = 90
  min_retention_days  = 180
}





