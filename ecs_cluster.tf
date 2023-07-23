resource "aws_ecs_cluster" "flaskapp_cluster" {
  name = "flaskapp-cluster"
}

/*resource "aws_ecs_capacity_provider" "flaskapp_capacity_provider" {
  name = "flaskapp_capacity_provider"
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.flaskapp.arn
    managed_scaling {
      target_capacity           = 1
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 1000
      status                    = "ENABLED"
    }
  }
}*/

# resource "aws_ecs_cluster_capacity_providers" "flaskapp_cluster_cp" {
#   cluster_name = aws_ecs_cluster.flaskapp_cluster.name

#   capacity_providers = aws_autoscaling_group.flaskapp.id

#   default_capacity_provider_strategy {
#     base              = 1
#     weight            = 100
#     capacity_provider = "FARGATE"
#   }
# }

resource "aws_ecs_service" "flaskapp_service" {
  name            = "flaskapp-service"
  cluster         = aws_ecs_cluster.flaskapp_cluster.id       # Referencing our created Cluster
  task_definition = aws_ecs_task_definition.flaskapp_task.arn # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 2 # Setting the number of containers we want deployed to 2
  # capacity_provider_strategy {
  #   capacity_provider = aws_ecs_capacity_provider.flaskapp_capacity_provider.name
  # }

  load_balancer {
    target_group_arn = aws_lb_target_group.flaskapp_target_group.arn # Referencing our target group
    container_name   = aws_ecs_task_definition.flaskapp_task.family
    container_port   = 5000 # Specifying the container port
  }

  network_configuration {
    subnets          = [aws_subnet.ecs_subnet_a.id, aws_subnet.ecs_subnet_b.id]
    assign_public_ip = true # Providing our containers with public IPs
    security_groups  = [aws_security_group.service_security_group.id]
  }
  depends_on = [aws_lb_listener.flaskapp_listener]
}

# resource "aws_iam_role" "ecsTaskExecutionRole_1" {
#   name               = "ecsTaskExecutionRole_1"
#   assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
# }

# data "aws_iam_policy_document" "assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["ecs-tasks.amazonaws.com"]
#     }
#   }
# }

# resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
#   role       = aws_iam_role.ecsTaskExecutionRole_1.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

# resource "aws_ecs_task_definition" "flaskapp" {
#   family                   = "flaskapp" #Naming our first task
#   container_definitions    = <<TASK_DEFINITION
#   [
#     {
#       "name": "flaskapp",
#       "image": "895792017190.dkr.ecr.eu-west-1.amazonaws.com/flaskapp_ecr_repo:latest",
#       "essential": true,
#       "portMappings": [
#         {
#           "containerPort": 5000
#         }
#       ],
#       "memory": 2048,
#       "cpu": 1024
#     }
#   ]
#   TASK_DEFINITION
#   requires_compatibilities = ["EC2"]  # Stating that we are using ECS Fargate
#   network_mode             = "awsvpc" # Using awsvpc as our network mode as this is required for Fargate
#   memory                   = 2048     # Specifying the memory our container requires
#   cpu                      = 1024     # Specifying the CPU our container requires
#   execution_role_arn       = aws_iam_role.ecsTaskExecutionRole_1.arn
# }

#   requires_compatibilities = ["EC2"]
#   networkMode              = "awsvpc"
#   cpu                      = 1024
#   memory                   = 2048
#   execution_role_arn       = data.aws_iam_role.flaskapp-ecs-task.arn

#   container_definitions = jsondecode([
#     {
#       image : "895792017190.dkr.ecr.eu-west-1.amazonaws.com/flaskapp_ecr_repo:latest",
#       cpu : 1024,
#       memory : 2048,
#       network_mode = "awsvpc",
#       name : "flaskapp",
#       portMappings : [
#         {
#           "containerPort" : 5000,
#           "hostPort" : 5000
#         }
#       ]
#     }
#   ])
# }
