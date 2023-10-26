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
resource "aws_subnet" "elkholy-subnet" {
  vpc_id = aws_vpc.elkholy-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "elkholy-subnet"
  }
}
resource "aws_instance" "lab1" {
  ami = "ami-03c25e6a40ef25506"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.elkholy-subnet.id
  tags = {
    Name = "elkholy-lab1"
  }
}