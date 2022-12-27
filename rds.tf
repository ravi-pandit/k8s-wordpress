# Secert Manager
# * Create Secret and Use in RDS

resource "random_password" "master" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "random_string" "random" {
  length  = 16
  special = false
  #override_special = "_!%^"
}
resource "aws_secretsmanager_secret" "password" {
  name = "terraform-password-${random_string.random.result}"
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = aws_secretsmanager_secret.password.id
  secret_string = random_password.master.result
}

# RDS resource
# * Use AWS Secret for master password
# * Use Newly Created VPC

# resource "aws_subnet" "demo_subnet" {
#   count             = 3
#   availability_zone = element(data.aws_availability_zones.available.names, count.index)
#   cidr_block        = element(var.cidr, count.index)
#   vpc_id            = aws_vpc.demo_vpc.id
#   tags = {
#     name = terraform_subnet
#   }
# }

resource "aws_db_subnet_group" "db_subnet_main" {
  name       = "subnet-group-terraform"
  subnet_ids = formatlist("%s", aws_subnet.private_demo_subnet.*.id)

  tags = {
    name = "terraform_db_subnet"
  }
}

resource "aws_db_instance" "main" {
  allocated_storage     = 20
  storage_type          = "gp2"
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = var.instance_class
  max_allocated_storage = 100
  db_name               = "terraform_${var.project}"
  identifier            = "terraform-${var.project}-1"
  username              = var.username
  password              = aws_secretsmanager_secret_version.password.secret_string
  db_subnet_group_name  = aws_db_subnet_group.db_subnet_main.id
  tags = {
    name = "RDS_Laravel"
  }
  publicly_accessible          = "false"
  multi_az                     = var.multi_az
  skip_final_snapshot          = true
  performance_insights_enabled = false
}
