# Infraestructura como código (IaC)
# Nicolás Adolfo Castillo Betancourt - nacastillo@bancodeoccidente.com.co
# Ejercicio #3 Creación EC2


provider "aws" {
  region = "us-east-2"  # Ohio region
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "ID de la AMI de Amazon Linux 2 4.14"
  default     = "ami-0c55b159cbfafe1f0"  # AMI de Amazon Linux 2
}

variable "volume_size" {
  description = "Tamaño del almacenamiento en GB"
  default     = 30
}

variable "vpc_id" {
  description = "ID de la VPC"
  default     = "vpc-0123456789abcdef0"  # ID de la VPC 
}

variable "subnet_id" {
  description = "ID de la Subnet"
  default     = "subnet-0123456789abcdef0"  # ID de la Subnet 
}

resource "aws_instance" "nacastillo_instance" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  key_name        = "nacastillo-key-name"  
  security_group  = aws_security_group.nacastillo_security_group.id

  root_block_device {
    volume_size = var.volume_size
  }

  tags = {
    Name = "nacastillo-instance"
  }
}

resource "aws_security_group" "nacastillo_security_group" {
  name        = "nacastillo-security-group"
  description = "Security group para la instancia EC2"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
