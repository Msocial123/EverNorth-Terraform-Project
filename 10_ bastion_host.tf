# https://medium.com/cloud-native-daily/aws-bastion-instance-using-terraform-module-f5df2d309f98
# https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest
module "ec2_bastion_instance" {
  depends_on = [module.vpc]
  source     = "terraform-aws-modules/ec2-instance/aws"

  name                   = "Bastion-Instance"
  ami                    = "ami-0c101f26f147fa7fd" #Amazon Linux UPDATE as PER YOUR REGION
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.bastion_host.id]
  key_name               = var.ec2_key_name

  iam_instance_profile = aws_iam_instance_profile.bastion_host_iam_instance_profile.name
   #This role later will be added in cluster aws-auth config to access cluster from bastion vm

  # Bootstrap script for Amazon Linux
  user_data = file("Bastion_host_bootstrap.sh")
}

# Algorith used to generate pub-pri ssh key pair
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Public Key associated with bastion host
resource "aws_key_pair" "tf-key-pair" {
  key_name   = var.ec2_key_name
  public_key = tls_private_key.rsa.public_key_openssh
}

# Private key file will be saved on your local machine in same directory
# On your local machine rename the file with .pem

resource "local_file" "tf-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "${var.ec2_key_name}.pem"
}