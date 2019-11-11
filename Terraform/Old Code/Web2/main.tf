# Web server with user data & security group, key pair


provider  "aws" {
	
	access_key = "${var.aws_access_key}"
	secret_key = "${var.aws_secret_key}"
	region = "us-east-1"
}

resource "aws_security_group" "securitygroup" {

	ingress{
	
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	
	}
	
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		}

	tags {

		Name = "SecurityGroup"
	}
}

resource "aws_key_pair" "keypair" {

	key_name   = "${var.key_name}"
	public_key = "${file(var.public_key_path)}"
	
}

resource "aws_instance" "instance" {

	ami = "ami-4fffc834"
	instance_type = "t2.micro"
	key_name = "${aws_key_pair.keypair.id}"
	vpc_security_group_ids = ["${aws_security_group.securitygroup.id}"]
	
	user_data = <<-EOF
	#!/bin/bash
    yum update -y
    yum install httpd -y
    service httpd start
    chkconfig httpd on
    cd /var/www/html
    echo "<h1><html>Hello Cloud Gurus!</html></h1>" > index.html
    EOF
	
	
	tags {
	
		Name = "WebServer"
	
	}

}


