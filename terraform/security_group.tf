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
  cidr_ipv4         = var.own_ip

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

# Kinds security group
resource "aws_security_group" "kinds_sg" {
  name        = "${var.project_name}-kinds-sg"
  description = "Security group for Kinds EC2 instance"
  vpc_id      = aws_vpc.main_vpc.id
}

# SSH from own IP to kinds instance
resource "aws_vpc_security_group_ingress_rule" "kind_ssh_ingress" {
  security_group_id = aws_security_group.kinds_sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = var.own_ip
}

# Kubernetes API — Jenkins needs this to run kubectl/helm commands
resource "aws_vpc_security_group_ingress_rule" "jenkins_to_kind_ingress" {
  security_group_id            = aws_security_group.kinds_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 6443
  to_port                      = 6443
  referenced_security_group_id = aws_security_group.jenkins_sg.id

  tags = merge(local.common, {
    Name = "${var.project_name}-jenkins-to-kinds-ingress"
  })
}

# NodePort range — to access deployed apps during verification
resource "aws_vpc_security_group_ingress_rule" "nodeport_ingress" {
  security_group_id            = aws_security_group.kinds_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 30000
  to_port                      = 32767
  referenced_security_group_id = aws_security_group.jenkins_sg.id

  tags = merge(local.common, {
    Name = "${var.project_name}-kinds-nodeport-ingress"
  })
}

# All outbound — needed to pull images from ECR
resource "aws_vpc_security_group_egress_rule" "kind_egress" {
  security_group_id = aws_security_group.kinds_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = merge(local.common, {
    Name = "${var.project_name}-kinds-sg-egress"
  })
}