# Security group para la bd
resource "aws_security_group" "mysql-sg" {
  vpc_id            = var.vpc_id
  name              = "${var.prefix_name}-sg-database"
  description       = "security group para la base de datos"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.webserver_sg_id
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
  tags = {
    Name = "${var.prefix_name}-sg-database"
  }
}

# Subnets para la db
resource "aws_db_subnet_group" "mysql-subnet" {
  name        = "mysqldb-subnet"
  description = "RDS grupo subnet"
  subnet_ids  = var.private_subnet_ids
}

# Parameters of the db (mysql)
# resource "aws_db_parameter_group" "mysql-parameters" {
#   name        = "mysql-params"
#   family      = "mysql10.2"
#   description = "mysql parameter group"

#   ## Parameters example
#   # parameter {
#   #   name  = "max_allowed_packet"
#   #   value = 16777216
#   # }
# }

# instancia de base de datos
resource "aws_db_instance" "mysql" {
  allocated_storage         = var.storage_gb
  engine                    = "mysql"
  engine_version            = var.mysql_version
  instance_class            = var.mysql_instance_type
  identifier                = "mysql"
  name                      = var.db_name
  username                  = var.db_username
  password                  = var.db_password
  db_subnet_group_name      = aws_db_subnet_group.mysql-subnet.name
  multi_az                  = var.is_multi_az
  vpc_security_group_ids    = [aws_security_group.mysql-sg.id]
  storage_type              = var.storage_type
  backup_retention_period   = 5
  skip_final_snapshot = true
  apply_immediately = true
  # final_snapshot_identifier = "${var.prefix_name}-mysql-snapshot" # final snapshot when executing terraform destroy
  tags = {
    Name = "${var.prefix_name}-mysql"
  }
}
