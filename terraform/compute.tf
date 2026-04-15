data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "jenkins" {
  ami                         = data.aws_ami.ubuntu_ami.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_pair_name
  iam_instance_profile        = aws_iam_instance_profile.jenkins_profile.name
  tags = merge(local.common, {
    Name = "${var.project_name}-jenkins"
  })

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

}

# K3s EC2 instance
resource "aws_instance" "k3s" {
  ami                         = data.aws_ami.ubuntu_ami.id
  instance_type               = var.k3s_instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.k3s_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_pair_name
  iam_instance_profile        = aws_iam_instance_profile.k3s_profile.name
  tags = merge(local.common, {
    Name = "${var.project_name}-k3s"
  })

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }
}