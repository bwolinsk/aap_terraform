provider "aws" {
  region  = "us-east-1"
}

resource "aws_vpc" "tf_vpc" {
  cidr_block = "192.168.22.0/24"

  tags = {
    Name = "tf_vpc"
  }
}

resource "aws_internet_gateway" "tf_gateway" {
  vpc_id = aws_vpc.tf_vpc.id
 
  tags = {
    Name = "tf_gateway"
  }
}

resource "aws_subnet" "tf_subnet" {
  vpc_id     = aws_vpc.tf_vpc.id
  cidr_block = "192.168.22.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "tf_subnet"
  }
}

resource "aws_security_group" "Terraform_Demo_SG" {

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami = "ami-0c9978668f8d55984"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.Terraform_Demo_SG.name]
  key_name      = "controller_bart"
  count         = "1"
  subnet_id     = aws_subnet.tf_subnet.id
}

output "address" {
  value = aws_instance.example.*.public_dns
}

output "ip_address" {
  value = aws_instance.example.*.public_ip
}
