resource "aws_lb" "my_ec2_lb" {
  name               = "ec2-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  enable_deletion_protection = false
  tags = {
    Environment = "dev"
  }
}

####
resource "aws_lb_target_group" "test" {
  name     = "tf-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_dev.id
}

####
resource "aws_lb_target_group_attachment" "private_instance-1" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.myEc2_private_1.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "private_instance-2" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.myEc2_private_2.id
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.my_ec2_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

output "load_balancer_dns" {
  value = aws_lb.my_ec2_lb.dns_name
}