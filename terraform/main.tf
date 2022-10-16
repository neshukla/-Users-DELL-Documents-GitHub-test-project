provider "aws" {
  profile = "default"
  region = "us-east-2"
}

resource "random_string" "flask-secret-key" "sys-stats-secret-key" "nginx-secret-key" {
  length = 16
  special = true
  override_special = "/@\" "
}


resource "aws_ecs_cluster" "fp-ecs-cluster" {
  name = "flask-app"
  tags = {
    Name = "flask-app"
  }
    name = "sys-stats-app"

  tags = {
    Name = "sys-stats-app"
  }
    name = "nginx-app"

  tags = {
    Name = "nginx-app"
  }
}

# create and define the container task
resource "aws_ecs_task_definition" "fp-ecs-task" {
  family = "flask-app"
  family = "sys-stats-app"
  family = "nginx-app"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = 512
  memory = 2048
  container_definitions = <<DEFINITION
[
   {
      "name":"flask-app",
      "image":"${var.flask_app_image}",
      "essential":true,
      "portMappings":[
         {
            "containerPort":5000,
            "hostPort":5000,
            "protocol":"tcp"
         }
      ],
      "environment":[
         {
            "name":"POSTGRES_USER",
            "value":"${aws_db_instance.fp-rds.username}"
         },
         {
            "name":"POSTGRES_PASSWORD",
            "value":"${aws_db_instance.fp-rds.password}"
         },
         {
            "name":"POSTGRES_ENDPOINT",
            "value":"${aws_db_instance.fp-rds.endpoint}"
         },
         {
            "name":"POSTGRES_DATABASE",
            "value":"${aws_db_instance.fp-rds.name}"
         },
         {
            "name":"FLASK_APP",
            "value":"${var.flask_app}"
         },
         {
            "name":"FLASK_ENV",
            "value":"${var.flask_env}"
         },
         {
            "name":"APP_HOME",
            "value":"${var.flask_app_home}"
         },
         {
            "name":"APP_PORT",
            "value":"${var.flask_app_port}"
         },
         {
            "name":"APP_SECRET_KEY",
            "value":"${random_string.flask-secret-key.result}"
         }
      ]
   }

  {
      "name":"sys-stats-app",
      "image":"${var.sys-stats_app_image}",
      "essential":true,
      "portMappings":[
         {
            "containerPort":3000,
            "hostPort":3000,
            "protocol":"tcp"
         }
      ],
      "environment":[
         {
            "name":"POSTGRES_USER",
            "value":"${aws_db_instance.fp-rds.username}"
         },
         {
            "name":"POSTGRES_PASSWORD",
            "value":"${aws_db_instance.fp-rds.password}"
         },
         {
            "name":"POSTGRES_ENDPOINT",
            "value":"${aws_db_instance.fp-rds.endpoint}"
         },
         {
            "name":"POSTGRES_DATABASE",
            "value":"${aws_db_instance.fp-rds.name}"
         },
         {
            "name":"sys-stats_APP",
            "value":"${var.sys-stats_app}"
         },
         {
            "name":"sys-stats_ENV",
            "value":"${var.sys-stats_env}"
         },
         {
            "name":"sys-stats_APP_HOME",
            "value":"${var.sys-stats_app_home}"
         },
         {
            "name":"sys-stats_APP_PORT",
            "value":"${var.sys-stats_app_port}"
         },
         {
            "name":"sys-stats_APP_SECRET_KEY",
            "value":"${random_string.sys-stats--secret-key.result}"
         }
      ]
   }

  {
      "name":"nginx-app",
      "image":"${var.nginx_app_image}",
      "essential":true,
      "portMappings":[
         {
            "containerPort":80,
            "hostPort":80,
            "protocol":"tcp"
         }
      ],
      "environment":[
         {
            "name":"POSTGRES_USER",
            "value":"${aws_db_instance.fp-rds.username}"
         },
         {
            "name":"POSTGRES_PASSWORD",
            "value":"${aws_db_instance.fp-rds.password}"
         },
         {
            "name":"POSTGRES_ENDPOINT",
            "value":"${aws_db_instance.fp-rds.endpoint}"
         },
         {
            "name":"POSTGRES_DATABASE",
            "value":"${aws_db_instance.fp-rds.name}"
         },
         {
            "name":"nginx_APP",
            "value":"${var.nginx_app}"
         },
         {
            "name":"nginx_ENV",
            "value":"${var.nginx_env}"
         },
         {
            "name":"nginx_APP_HOME",
            "value":"${var.nginx_app_home}"
         },
         {
            "name":"nginx_APP_PORT",
            "value":"${var.nginx_app_port}"
         },
         {
            "name":"nginx_APP_SECRET_KEY",
            "value":"${random_string.nginx-secret-key.result}"
         }
      ]
   }
]
DEFINITION
}

resource "aws_ecs_service" "flask-service" {
  name = "flask-app-service"
  cluster = aws_ecs_cluster.fp-ecs-cluster.id
  task_definition = aws_ecs_task_definition.fp-ecs-task.arn
  desired_count = 2
  launch_type = "FARGATE"

  resource "aws_ecs_service" "sys-stats-service" {
  name = "sys-stats-app-service"
  cluster = aws_ecs_cluster.fp-ecs-cluster.id
  task_definition = aws_ecs_task_definition.fp-ecs-task.arn
  desired_count = 2
  launch_type = "FARGATE"

  resource "aws_ecs_service" "nginx-service" {
  name = "nginx-app-service"
  cluster = aws_ecs_cluster.fp-ecs-cluster.id
  task_definition = aws_ecs_task_definition.fp-ecs-task.arn
  desired_count = 2
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.fp-ecs-sg.id]
    subnets = aws_subnet.fp-public-subnets.*.id
    assign_public_ip = true
  }

  load_balancer {
    container_name = "flask-app"
    container_port = var.flask_app_port
    target_group_arn = aws_alb_target_group.fp-target-group.id
  }
  load_balancer {
    container_name = "sys-stats-app"
    container_port = var.sys-stats_app_port
    target_group_arn = aws_alb_target_group.fp-target-group.id
  }
    load_balancer {
    container_name = "nginx-app"
    container_port = var.nginx_app_port
    target_group_arn = aws_alb_target_group.fp-target-group.id
  }

  depends_on = [
    aws_alb_listener.fp-alb-listener
  ]
}