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
              nohup busybox httpd f p ${var.server_port} &
              EOF

}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = var.server_port
    protocol = "tcp"
    to_port = var.server_port
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}

output "public_ip" {
  value = aws_instance.exmaple.public_ip
  description = "The public IP address of the web server"
}