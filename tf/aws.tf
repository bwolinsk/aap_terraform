provider "aws" {
  region = "us-east-1"
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

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  }
  ]
}

resource "aws_instance" "example" {
  ami = "ami-0c9978668f8d55984"
  instance_type = "t2.micro"
  key_name      = "controller_bart"
  count         = "1"
  subnet_id     = aws_subnet.tf_subnet.id
  security_groups = [aws_security_group.main.name]
}

output "address" {
  value = aws_instance.example.*.public_dns
}

output "ip_address" {
  value = aws_instance.example.*.public_ip
}
