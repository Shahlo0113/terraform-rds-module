terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  cloud {
    organization = "summercloud"

    workspaces {
      name = "rds-module"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "demodb"

  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3.micro"
  allocated_storage = 5

  db_name                             = "demodb"
  username                            = "user"
  port                                = "3306"
  iam_database_authentication_enabled = true

  vpc_security_group_ids = ["sg-0b81f81c272c8e697"]

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = ["subnet-07fc84f7681afb574", "subnet-039744b3118b3a404"]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = true

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}