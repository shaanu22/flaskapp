resource "aws_lb" "flaskapp_ecs_application_lb" {
  name               = "flaskapp-lb" # Naming our load balancer
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.ecs_subnet_a.id, aws_subnet.ecs_subnet_b.id]
  # Referencing the security group
  security_groups = [aws_security_group.flaskapp_ecs_load_balancer_sg.id]
  tags = {
    name = "flaskapp_lb"
  }
}

# Creating a security group for the load balancer:
resource "aws_security_group" "flaskapp_ecs_load_balancer_sg" {
  name        = "ecs-lb-sg"
  description = "flaskapp lb security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80 #Allowing traffic in from port 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic in from all sources
  }

  ingress {
    from_port   = 443 #Allowing traffic in from port 80
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic in from all sources
  }

  egress {
    from_port   = 0             # Allowing any incoming port
    to_port     = 0             # Allowing any outgoing port
    protocol    = "-1"          # Allowing any outgoing protocol 
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}

# resource "aws_lb_target_group_attachment" "flaskapp_tg_attach" {
#   target_group_arn = aws_lb_target_group.flaskapp_target_group.arn
#   target_id        = aws_ecs_task_definition.flaskapp.id
#   port             = 80
# }

resource "aws_lb_listener" "flaskapp_listener" {
  load_balancer_arn = aws_lb.flaskapp_ecs_application_lb.arn # Referencing our load balancer
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flaskapp_target_group.arn # Referencing our tagrte group
  }
}

# resource "aws_lb_target_group" "flaskapp_target_group" {
#   name        = "flaskapp-target-group"
#   port        = 5000
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = aws_vpc.main.id # Referencing the default VPC
#   health_check {
#     healthy_threshold   = "2"
#     unhealthy_threshold = "3"
#     interval            = "30"
#     matcher             = "200,301,302"
#     path                = "/*"
#     protocol            = "HTTP"
#   }
# }

