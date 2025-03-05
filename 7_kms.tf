# KMS key used for encryption and decryption and 
# to be used by Secrets Manager password encryption for RDS
module "kms" {
  source                  = "terraform-aws-modules/kms/aws"
  version                 = "2.2.1"
  aliases                 = ["one"]
  description             = "KMS key for-RDS"
  enable_key_rotation     = true
  is_enabled              = true
  deletion_window_in_days = 7

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

}

module "secrets_manager" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "1.1.2"

  name                    = "RDS_VAULT-2"
  description             = "A room with a strong door and thick walls in a bank encrypted using kms key"
  kms_key_id              = module.kms.key_id
  recovery_window_in_days = 0

  create_random_password           = true
  random_password_length           = 16
  random_password_override_special = "!@#$%^&*()_+"


  # Version
  # ignore_secret_changes = true
  # secret_string = jsonencode({
  #   db_username = "root",
  #   db_password = "Kickdrum3d!",
  #   db_port     = 3306
  # })

  tags = {
    Environment = "Development"
    Project     = "Example"
  }

}



data "aws_secretsmanager_secret_version" "secret_credentials" {
  secret_id = module.secrets_manager.secret_id
  depends_on = [
    module.secrets_manager
  ]
}