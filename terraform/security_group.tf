resource "aws_security_group" "jenkins_sg" {
  name        = "${var.project_name}-jenkins-sg"
  description = "Security of jenkins server"
  vpc_id      = aws_vpc.main_vpc.id

  tags = merge(local.common, {
    Name = "${var.project_name}-jenkins-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ssh_ingress" {
  security_group_id = aws_security_group.jenkins_sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = var.own_ip

  tags = merge(local.common, {
    Name = "${var.project_name}-ssh-ingress"
  })
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_web_ui_ingress" {
  security_group_id = aws_security_group.jenkins_sg.id
  ip_protocol       = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_ipv4         = "0.0.0.0/0"

  tags = merge(local.common, {
    Name = "${var.project_name}-jenkins-web-ui-ingress"
  })
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.jenkins_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = merge(local.common, {
    Name = "${var.project_name}-jenkins-sg-egress"
  })
}

# K3s security group
resource "aws_security_group" "k3s_sg" {
  name        = "${var.project_name}-k3s-sg"
  description = "Security group for K3s EC2 instance"
  vpc_id      = aws_vpc.main_vpc.id
}

# SSH from own IP to k3s instance
resource "aws_vpc_security_group_ingress_rule" "k3s_ssh_ingress" {
  security_group_id = aws_security_group.k3s_sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = var.own_ip
}

# Kubernetes API — Jenkins needs this to run kubectl/helm commands
resource "aws_vpc_security_group_ingress_rule" "jenkins_to_k3s_ingress" {
  security_group_id            = aws_security_group.k3s_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 6443
  to_port                      = 6443
  referenced_security_group_id = aws_security_group.jenkins_sg.id

  tags = merge(local.common, {
    Name = "${var.project_name}-jenkins-to-k3s-ingress"
  })
}

# NodePort range — to access deployed apps during verification
resource "aws_vpc_security_group_ingress_rule" "nodeport_ingress" {
  security_group_id            = aws_security_group.k3s_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 30000
  to_port                      = 32767
  referenced_security_group_id = aws_security_group.jenkins_sg.id

  tags = merge(local.common, {
    Name = "${var.project_name}-k3s-nodeport-ingress"
  })
}

# All outbound — needed to pull images from ECR
resource "aws_vpc_security_group_egress_rule" "k3s_egress" {
  security_group_id = aws_security_group.k3s_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = merge(local.common, {
    Name = "${var.project_name}-k3s-sg-egress"
  })
}