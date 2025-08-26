resource "aws_vpc" "test_vpc"{
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

resource "aws_lb" "test_lb" {
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

resource "aws_lb_listener" "test_listener" {
  load_balancer_arn = aws_lb.test_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn = aws_lb_target_group.test_target_group.arn
      }
    }
  }
}

resource "aws_lb_target_group" "test_target_group" {
  name     = "Testing_Target_Group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.test_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold  = 2
    unhealthy_threshold = 2
  }
}

resource "aws_instance" "test_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.test_vpc_subnet.id
  security_groups = [aws_security_group.aws_sg.name]

  tags = {
    Name = "TestInstance"
  }
}
resource "aws_lb_target_group_attachment" "test_attachment" {
  target_group_arn = aws_lb_target_group.test_target_group.arn
  target_id        = aws_instance.test_instance.id
  port             = 80
}
resource "aws_route_table" "routetable" {
    vpc_id = aws_vpc.test_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "Test_Route_Table"
    }
}
