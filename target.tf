resource "aws_lb_target_group" "flaskapp_target_group" {
  name_prefix = "flask"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id
  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "6"
    interval            = "60"
    matcher             = "200,301,302"
    path                = "/"
    protocol            = "HTTP"
    timeout             = "30"
  }
  tags = {
    name = "flaskapp_target_group"
  }

  #depends_on = [aws_lb.flaskapp_ecs_application_lb]

  lifecycle {
    create_before_destroy = true
  }
}
