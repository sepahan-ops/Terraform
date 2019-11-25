provider "aws" {
  region = "us-east-1"
}

resource "aws_launch_configuration" "exmaple" {
  image_id = "ami-076e36b130f0652ac"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.instance.id]

  tags = {
    Name = "terraform-example"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index . html
              nohup busybox httpd f p ${var.server_port} &
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.exmaple.name
  vpc_zone_identifier = data.aws_subnet_ids.default.id

  max_size = 2
  min_size = 10

  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
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
  value = aws_launch_configuration.exmaple.associate_public_ip_address
  description = "The public IP address of the web server"
}