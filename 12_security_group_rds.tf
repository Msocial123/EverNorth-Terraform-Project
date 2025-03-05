# Creating a new security group for RDS 
resource "aws_security_group" "rds-sg" {
  depends_on  = [module.vpc]
  name        = var.rds_security_group_name
  description = "rds-sg created By Terraform"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_host.id] # Source to RDS is SG of bastion host # Input from Bastion host SG
    description     = "Allow inbound MySQL traffic from Bastion host in public subnet"
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id] # Source to RDS is SG of EKS worker nodes # Input from  EKS node /POD SG
    description     = "Allow inbound MySQL traffic from EKS worker nodes"
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_address] # Replace "your_ip_address" with your actual IP address
    description = "Allow inbound MySQL traffic from your IP address"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}