resource "aws_lb_target_group" "wordpress-tg" {
  name_prefix        = "wordpress-tg"
  port               = 80
  protocol           = "HTTP"
  vpc_id             = aws_vpc.demo_vpc.id

  health_check {
    healthy_threshold   = 2
    interval            = 30
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    path                = "/wp-admin/install.php"
  }
}


resource "aws_lb_target_group" "green-tg" {
  name_prefix        = "green-tg"
  port               = 80
  protocol           = "HTTP"
  vpc_id             = aws_vpc.demo_vpc.id

  health_check {
    healthy_threshold   = 2
    interval            = 30
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    path                = "/green/index.html"
  }
}