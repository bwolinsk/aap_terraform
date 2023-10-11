provider "aws" {
  region  = "eu-north-1"
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

resource "aws_instance" "example" {
  ami = "ami-0874ff0d73a3ab8cf"
  instance_type = "t2.micro"
  key_name      = "insights_controller"
  count         = "1"
  subnet_id     = aws_subnet.tf_subnet.id
}

output "address" {
  value = aws_instance.example.*.public_dns
}

output "ip_address" {
  value = aws_instance.example.*.public_ip
}
