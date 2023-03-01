provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "tf_vpc" {
  cidr_block = "192.168.22.0/24"

  tags = {
    Name = "tf_vpc"
  }
}

resource "aws_subnet" "tf_subnet" {
  vpc_id     = aws_vpc.tf_vpc.id
  cidr_block = "192.168.22.0/24"

  tags = {
    Name = "tf_subnet"
  }
}

resource "aws_instance" "example" {
  ami = "ami-0c9978668f8d55984"
  instance_type = "t2.micro"
  key_name      = "controller_bart"
  count         = "1"
  subnet_id     = aws_subnet.tf_subnet.id
}

resource "aws_eip" "tf_eip" {
  instance = aws_instance.example[0].id
  vpc = true
}

resource "aws_eip_association" "tf_eip_association" {
  instance_id = aws_instance.example[0].id
  allocation_id = "eipalloc-01da02aa45306e506"
}

output "address" {
  value = aws_instance.example.*.public_dns
}
