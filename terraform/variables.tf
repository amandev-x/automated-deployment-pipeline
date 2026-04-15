variable "project_name" {
  description = "Project name"
  type        = string
  default     = "automated-deployment-pipeline"
}

variable "vpc_cidr_block" {
  description = "VPC cidr block address"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
  description = "Enable dns hostname"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable dns support"
  type        = bool
  default     = true
}

variable "subnet_cidr_block" {
  description = "Subnet cidr block"
  type        = string
  default     = "10.0.0.0/24"
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
  default     = "ap-south-1a"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "own_ip" {
  description = "IP address of your"
  type        = string
}

# variable "subnet_id" {
#   description = "Subnet ID for Jenkins EC2 instance"
#   type        = string
# }

variable "key_pair_name" {
  description = "Key pair name"
  type        = string
}

variable "iam_role_name" {
  description = "IAM role name"
  type        = string
  default     = "jenkins-ec2-role"
}

variable "kinds_instance_type" {
  description = "Kinds instance type"
  type        = string
  default     = "t3.small"
}

variable "kinds_iam_role_name" {
  description = "Kinds iam role name"
  type        = string
  default     = "kinds-ec2-role"
}

# variable "vpc_id" {
#   description = "VPC Id"
#   type        = string

# }
