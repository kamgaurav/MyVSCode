#1. Create VPC
#2. Create Subnets in VPC
#3. Create Internet gateway
#4. Create Route Table in VPC-
#	1. add route to IGW
#	2. associate subnets from VPC
#5. Enable auto-assign IP settings for one of subnet


provider "aws" {

	access_key = "${var.aws_access_key}"
	secret_key = "${var.aws_secret_key}"
	region = "us-east-1"
	
}

resource "aws_vpc" "VPC" {

	cidr_block = "10.0.0.0/16"
	
	tags{
	
		Name = "VPC1"
		
	}
}

resource "aws_subnet" "Public" {

	vpc_id = "${aws_vpc.VPC.id}"
	availability_zone = "us-east-1a"
	cidr_block = "10.0.1.0/24"
	
	tags{
	
		Name = "Public_Subnet"
	}
}


resource "aws_subnet" "Private" {

	vpc_id = "${aws_vpc.VPC.id}"
	availability_zone = "us-east-1b"
	cidr_block = "10.0.2.0/24"
	
	tags {
	
		Name = "Private_Subnet"
	}
}

resource "aws_internet_gateway" "IGW" {
	
	vpc_id = "${aws_vpc.VPC.id}"

	tags {
	
		Name = "IGW"
	
	}
}

resource "aws_route_table" "PublicRoute" {

	vpc_id = "${aws_vpc.VPC.id}"
	
	route{
	
	cidr_block = "0.0.0.0/0"
	gateway_id = "${aws_internet_gateway.IGW.id}"
	
	}
	
	tags {
	
		Name = "PublicRoute"
	}
}

resource "aws_route_table_association" "RTAssociation" {

	subnet_id = "${aws_subnet.Public.id}"
	route_table_id = "${aws_route_table.PublicRoute.id}"
	
	
}


resource "aws_security_group" "Public_Security_Group" {

vpc_id = "${aws_vpc.VPC.id}"

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

		Name = "Public_Security_Group"
	}
}


resource "aws_security_group" "Private_Security_Group" {

vpc_id = "${aws_vpc.VPC.id}"

	ingress{
	
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	
	}
	
	ingress{
	
		from_port = -1
		to_port = -1
		protocol = "icmp"
		cidr_blocks = ["0.0.0.0/0"]
	
	}
	
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		}

	tags {

		Name = "Private_Security_Group"
	}
}


resource "aws_key_pair" "keypair" {

	key_name   = "${var.key_name}"
	public_key = "${file(var.public_key_path)}"
	
}

resource "aws_instance" "Web" {

	ami = "ami-4fffc834"
	instance_type = "t2.micro"
	key_name = "${aws_key_pair.keypair.id}"
	subnet_id = "${aws_subnet.Public.id}"
	vpc_security_group_ids = ["${aws_security_group.Public_Security_Group.id}"]
	associate_public_ip_address = "true"
	
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

resource "aws_instance" "Database" {

	ami = "ami-4fffc834"
	instance_type = "t2.micro"
	key_name = "${aws_key_pair.keypair.id}"
	subnet_id = "${aws_subnet.Private.id}"
	vpc_security_group_ids = ["${aws_security_group.Private_Security_Group.id}"]
	associate_public_ip_address = "false"
	
	
	tags {
	
		Name = "Database"
	
	}
	
}