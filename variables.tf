variable "bucket_names" {
  description = "List of S3 bucket names"
  type        = list(string)
  default     = ["alt-s3-database-backup-test-v1", "alt-s3-database-backup-prod-v1", "alt-s3-app-backup-test-v1", "alt-s3-app-backup-prod-v1"]
}