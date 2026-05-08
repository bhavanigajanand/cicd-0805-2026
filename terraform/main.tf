terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ─────────────────────────────────────────
# Key Pair — generates a new RSA key and
# saves the .pem file locally
# ─────────────────────────────────────────
resource "tls_private_key" "cicd_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "cicd_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.cicd_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content         = tls_private_key.cicd_key.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0400"
}

# ─────────────────────────────────────────
# Security Group
# ─────────────────────────────────────────
resource "aws_security_group" "cicd_sg" {
  name        = "cicd-security-group"
  description = "Allow SSH, HTTP, Jenkins, and Flask"

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Jenkins
  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Flask App
  ingress {
    description = "Flask App"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cicd-sg"
  }
}

# ─────────────────────────────────────────
# EC2 Instance
# ─────────────────────────────────────────
resource "aws_instance" "cicd_server" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.cicd_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.cicd_sg.id]
  associate_public_ip_address = true

  user_data = file("${path.module}/userdata.sh")

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "cicd-jenkins-server"
  }
}

# ─────────────────────────────────────────
# Fetch latest Amazon Linux 2023 AMI
# ─────────────────────────────────────────
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
