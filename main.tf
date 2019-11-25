provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "exmaple" {
  ami = "ami-076e36b130f0652ac"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-example"
  }
}
