
# Create a VPC ----------------------------------------------------------------

resource "aws_vpc" "main" {
  cidr_block = "10.32.0.0/16"
}

# Create a Security Group ----------------------------------------------------------------

resource "aws_security_group" "security_group" {
  name = "security"
  vpc_id = aws_vpc.main.id

   ingress {
    description = "Allow traffic on port 8000"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]


  }
}
 
 
# Create a ECR Repository ----------------------------------------------------------------

resource "aws_ecr_repository" "amazon-ecs" {
  name                 = "amazon-ecs"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    name = "amazon-ecs"
  }
}

# Create a Task definition ----------------------------------------------------------------

resource "aws_ecs_task_definition" "service" {
  family                   = "service"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  network_mode             = "awsvpc"
  execution_role_arn = "arn:aws:iam::155170927437:role/ecs_access"

  
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "application",
    "command": ["yarn", "parcel", "src/index.html"],
    "image": "seeshellol/public-tamago-app:f78dd6cd99d092708550e66b931eec696135b044",
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
    "portMappings": [ 
            { 
               "containerPort": 8000,
               "hostPort": 8000,
               "protocol": "tcp"
            }
         ]
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}



# Create a ECS cluster ----------------------------------------------------------------

resource "aws_ecs_cluster" "project_cluster" {
  name = "app_cluster"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.32.1.0/24"

  tags = {
    Name = "Public"
  }
}

# Create a ECS service ----------------------------------------------------------------

resource "aws_ecs_service" "aws_service" {
  name            = "application"
  cluster         = aws_ecs_cluster.project_cluster.id
  task_definition = aws_ecs_task_definition.service.arn

  network_configuration {
  security_groups = [ aws_security_group.security_group.id ]
  subnets         = aws_subnet.public.*.id
  }
}


