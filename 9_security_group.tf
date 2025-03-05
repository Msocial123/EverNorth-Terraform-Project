# Creating security group for bastion host
resource "aws_security_group" "bastion_host" {
  name        = var.bastion_security_group_name
  description = "Allow SSH reated By Terraform"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.bastion_security_group_name
  }
}

#Need to attach EKS cluster
resource "aws_security_group" "bastion_host_to_cluster" {
  name        = "sg_bastion_host_to_cluster"
  description = "Allow 443 from bastion to cluster"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_host.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
      Name = "sg_bastion_host_to_cluster"
    }

  depends_on = [ aws_security_group.bastion_host ]
}

#We are creating a rule that allows any EC2 instance to assume or take on this IAM role
##This role later will be added in cluster aws-auth config to access cluster from bastion vm
resource "aws_iam_role" "bastion_host_iam_role" {
  name = "bastion_host_iam_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "bastion_host_iam_role"
  }
}

resource "aws_iam_instance_profile" "bastion_host_iam_instance_profile" {
  name = "bastion_host_iam_instance_profile"
  role = aws_iam_role.bastion_host_iam_role.name
}

