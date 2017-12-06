provider "aws" {
	region = "${var.region}"
	profile = "${var.profile}"
}

resource "aws_vpc" "vpc" {
	cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "internet-gateway" {
	vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "internet_access" {
	route_table_id 		= "${aws_vpc.vpc.main_route_table_id}"
	destination_cidr_block  = "0.0.0.0/0"
	gateway_id 		= "${aws_internet_gateway.internet-gateway.id}"
}

resource "aws_subnet" "default" {
	vpc_id			= "${aws_vpc.vpc.id}"
	cidr_block		= "10.0.1.0/24"
	map_public_ip_on_launch	= true
	
	tags {
		Name = "Public"
	}
}

resource "aws_security_group" "default" {
	name		= "terraform_security_group"
	description	= "Used for public instances"
	vpc_id		= "${aws_vpc.vpc.id}"

	ingress {
		from_port	= 22
		to_port		= 22
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}

	ingress {
		from_port	= 80
		to_port		= 80
		protocol	= "tcp"
		cidr_blocks	= ["0.0.0.0/0"]
	}

	egress {
		from_port	= 0
		to_port		= 0
		protocol	= "-1" # all protocols
		cidr_blocks	= ["0.0.0.0/0"]
	}
}

#resource "aws_key_pair" "auth" {
#	key_name 	= "$var.key_name}"
#	public_key	= "${file(var.public_key_path)}"
#}

resource "aws_instance" "web" {
	instance_type 	= "t2.micro"
	ami 		= ""

	#key_name	= "${aws_key_pair.auth.id}"
	vpc_security_group_ids = ["${aws_security_group.default.id}"]

	subnet_id 	= "${aws_subnet.default.id}"
	
	connection {
		user = "ubuntu"
	}

	provisioner "remote-exec" {
		inline = [
			"sudo apt-get -y update",
			"sudo apt-get -y install nginx",
			"sudo service nginx start"
		]

	}
}
