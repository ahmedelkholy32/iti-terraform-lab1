provider "aws" {
  region = "eu-west-1"
  profile = "terraform"
}
resource "aws_vpc" "elkholy-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "elkholy-vpc"
  }
}
resource "aws_internet_gateway" "elkholy-ig" {
  vpc_id = aws_vpc.elkholy-vpc.id
  tags = {
    Name = "elkholy-ig"
  }
}
resource "aws_route_table" "elkholy-rt" {
  vpc_id = aws_vpc.elkholy-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.elkholy-ig.id
  }
  tags = {
    Name = "elkoly-rt"
  }
}
resource "aws_subnet" "elkholy-subnet" {
  vpc_id = aws_vpc.elkholy-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "elkholy-subnet"
  }
}
resource "aws_route_table_association" "elkholy-art" {
  subnet_id = aws_subnet.elkholy-subnet.id
  route_table_id = aws_route_table.elkholy-rt.id
}
resource "aws_security_group" "elkholy-sg" {
  name = "allow_ssh"
  vpc_id = aws_vpc.elkholy-vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "elkholy-sg"
  }
}
data "aws_ami" "amazon-linux2" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = [ "al2023-ami-2023*" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
}
resource "aws_instance" "lab1" {
  ami = data.aws_ami.amazon-linux2.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.elkholy-subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.elkholy-sg.id]
  key_name = "iti-server"
  tags = {
    Name = "elkholy-lab1"
  }
}