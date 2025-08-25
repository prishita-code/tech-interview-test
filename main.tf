resource "aws_vpc" "test_vpc "{
    cidr_block = "10.0.1.0/16"
    enable_dns_hostnames = true

}
resource "aws_subnet" "test_vpc_subnet"{
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.test_vpc.vpc_id
    map_public_ip_on_launch = true
  
}
resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.test_vpc.vpc_id
}
resource "aws_security_group" "aws_sg" {
  name = "Testing_SG"
  description = "Creating my AWS Security group"
  vpc_id = aws_vpc.test_vpc.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "test_lb"{
    name = "Testing_LB"
    vpc_id = aws_vpc.test_vpc.id
    security_groups    = [aws_security_group.aws_sg.id]
    subnets            = [for subnet in aws_subnet.test_vpc_subnet : subnet.id]
    enable_deletion_protection = true

    access_logs {
    bucket  = "testlogs123456"
    enabled = true
  }
}


