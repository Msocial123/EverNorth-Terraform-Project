# Password sudo cat /var/lib/jenkins/secrets/initialAdminPassword
resource "aws_instance" "jenkins-server" {
  depends_on    = [module.vpc]
  ami           = "ami-04b70fa74e45c3917" # Need to change based on AWS Region 
  instance_type = "t2.medium"
  subnet_id     = module.vpc.public_subnets[0]
  key_name      = var.ec2_key_name

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
  }

  # Bootstrap script for Jenkins Ubuntu
  user_data                   = file("Jenkins_server_bootstrap.sh")
  user_data_replace_on_change = true

  vpc_security_group_ids = [aws_security_group.jenkins_server_sg.id]

  tags = {
    Name = "Jenkins server"
  }
}



# Password sudo cat /var/lib/jenkins/secrets/initialAdminPassword
resource "aws_instance" "sonar-server" {
  depends_on    = [module.vpc]
  ami           = "ami-04b70fa74e45c3917" # Need to change based on AWS Region 
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnets[0]
  key_name      = var.ec2_key_name

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
  }

  # Bootstrap script for Jenkins Ubuntu
  user_data                   = file("sonar_server_bootstrap_copy.sh")
  user_data_replace_on_change = true

  vpc_security_group_ids = [aws_security_group.jenkins_server_sg.id]

  tags = {
    Name = "Sonar server"
  }
}