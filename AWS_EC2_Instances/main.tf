variable "aws_key" {
  default = "C:/aws_keys/default-EC2.pem"
}

provider "aws" {
  region  = "ap-south-1"
  version = "~>4.30.0"
}
// HTTP server -> Security Group
//Security Group --> 80 TCP, 22 TCP, CIDER ["0.0.0.0/0"]

resource "aws_default_vpc" "default" {
}

data "aws_subnet_ids" "default_subnets" {
  vpc_id = aws_default_vpc.default.id
}


data "aws_ami_ids" "aws_linux_latest_ids" {
  owners = ["amazon"]
}

data "aws_ami" "aws_linux_latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}


resource "aws_security_group" "http_server_security_group" {
  name = "http_server_sg"
  # vpc_id = "vpc-0c829482552a96725"
  vpc_id = aws_default_vpc.default.id //dynamic

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    # description = "value"
    # ipv6_cidr_blocks = [ "value" ]
    # prefix_list_ids = [ "value" ]
    # security_groups = [ "value" ]
    # self = false
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22

  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = -1
    to_port     = 0
  }
  tags = {
    "name" = "http_server_sg"
  }
}

resource "aws_instance" "http_server" {

  # ami                    = "ami-06489866022e12a14"
  ami                    = data.aws_ami.aws_linux_latest.id //dynamic
  key_name               = "default-EC2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_security_group.id]
  # subnet_id              = "subnet-0146d7a69fe4e7ba0"
  subnet_id = tolist(data.aws_subnet_ids.default_subnets.ids)[0] //dynamic

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key)
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "echo Hey..Welcome to my world..⚡ - This Server is at ${self.public_dns} | sudo tee /var/www/html/index.html"
    ]
  }
  tags = {
    "name" = "HTTP-Server"
  }
}
