resource "aws_security_group" "service_security_group" {
  name        = "ecs-service-sg"
  description = "ecs security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 5000
    to_port   = 5000
    protocol  = "tcp"
    # Only allowing traffic in from the load balancer security group
    security_groups = [aws_security_group.flaskapp_ecs_load_balancer_sg.id]
  }

  egress {
    from_port   = 0             # Allowing any incoming port
    to_port     = 0             # Allowing any outgoing port
    protocol    = "-1"          # Allowing any outgoing protocol 
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}
