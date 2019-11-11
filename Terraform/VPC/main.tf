
# Create VPC- VPC1 with cidr 10.0.0.0/16
# Create Subnet
# Create ec2 instance & attach subnet to it

provider "aws" {
  
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}


resource "aws_vpc" "VPC" {
  cidr_block = "10.0.0.0/16"

	tags { 
		Name = "VPC1"
	}

}


resource "aws_subnet" "subnet" {

	vpc_id = "${aws_vpc.VPC.id}"
	availability_zone = "us-east-1a"
	cidr_block = "10.0.1.0/24"

	tags { 
		Name = "subnet1"

	}
}

resource "aws_instance"  "instance" {
	
	ami = "ami-4fffc834"
	instance_type = "t2.micro"
	subnet_id = "${aws_subnet.subnet.id}"
	
	tags {
	
		Name = "Instance1"
	}
}

