resource "aws_iam_role" "jenkins-ec2-role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          "Service" : "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ecr_full_access" {
  role       = aws_iam_role.jenkins-ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "${var.project_name}-jenkins-profile"
  role = aws_iam_role.jenkins-ec2-role.name
}

# K3s EC2 instance IAM role
resource "aws_iam_role" "k3s_ec2_role" {
  name = var.k3s_iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          "Service" : "ec2.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ecr_read_only" {
  role       = aws_iam_role.k3s_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "k3s_profile" {
  name = "${var.k3s_iam_role_name}-k3s-profile"
  role = aws_iam_role.k3s_ec2_role.name
}