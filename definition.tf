# resource "aws_ecs_task_definition" "flaskapp" {
#   family = "flaskapp"
#   container_definitions = jsonencode([
#     {
#       #requires_compatibilities = ["EC2"]
#       #networkMode = "awsvpc"
#       name        = "flaskapp"
#       image       = "895792017190.dkr.ecr.eu-west-1.amazonaws.com/flaskapp_ecr_repo:latest"
#       cpu         = 1024
#       memory      = 2048
#       networkMode = "awsvpc"
#       essential   = true
#       portMappings = [
#         {
#           containerPort = 5000
#           hostPort      = 5000
#         }
#       ]
#     }
#   ])

#   requires_compatibilities = ["EC2"]
#   network_mode             = "awsvpc"

#   execution_role_arn = data.aws_iam_role.ecsTaskExecutionRole_1.arn
# }

# resource "aws_iam_instance_profile" "flaskapp_ecs_agent" {
#   name = "flaskapp_ecs_agent"
#   role = aws_iam_role.ecsTaskExecutionRole.name
# }

resource "aws_ecs_task_definition" "flaskapp_task" {
  family                   = "flaskapp-task" # Naming our first task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "flaskapp-task",
      "image": "895792017190.dkr.ecr.eu-west-1.amazonaws.com/flaskapp-ecr-repo:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 5000,
          "hostPort": 5000
        }
      ],
      "memory": 2048,
      "cpu": 1024
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 2048        # Specifying the memory our container requires
  cpu                      = 1024        # Specifying the CPU our container requires
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
}
