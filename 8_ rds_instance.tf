#https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = module.vpc.database_subnets
}

module "rds_instance" {
  depends_on = [module.vpc]
  source     = "terraform-aws-modules/rds/aws"

  identifier        = "database-12"
  engine            = "mysql"
  engine_version    = "8.0.35"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = var.db_name
  username = var.db_username
  password = data.aws_secretsmanager_secret_version.secret_credentials.secret_string
  port     = var.db_port

  publicly_accessible = false #false for security

  # Enable access on port 3306
  vpc_security_group_ids = [aws_security_group.rds-sg.id] #Port 3306

  # Subnet Group
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # create_db_parameter_group = false
  create_db_option_group = false

  apply_immediately          = true
  auto_minor_version_upgrade = false
  deletion_protection        = false
  skip_final_snapshot        = true
  storage_encrypted          = false

  tags = {
    Creator     = "Ajay"
    Environment = "dev"
  }
}