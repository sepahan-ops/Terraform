provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "exmaple" {
  ami = "ami-076e36b130f0652ac"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  tags = {
    Name = "terraform-example"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index . html
              nohup busybox httpd f p 8080 &
              EOF

}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
}
