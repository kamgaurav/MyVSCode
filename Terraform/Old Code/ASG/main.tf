provider "aws" {
  region = "us-east-1"
 

}

data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "asg" {
  launch_configuration = "${aws_launch_configuration.lc.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  min_size = 2
  max_size = 3

  load_balancers = ["${aws_elb.elb.name}"]
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "terraform-asg"
    propagate_at_launch = true
  }
}


resource "aws_launch_configuration" "lc" {
  
  image_id = "ami-cd0f5cb6"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.sg.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

	lifecycle {
    create_before_destroy = true
  }
}




resource "aws_security_group" "sg" {
  name = "terraform-sg"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

         }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

	lifecycle {
    create_before_destroy = true
  }
}


resource "aws_elb" "elb" {
  name = "terraform-elb"
  security_groups = ["${aws_security_group.sg.id}"]
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 5
    target = "HTTP:${var.server_port}/"
  }

  # This adds a listener for incoming HTTP requests.
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }
}