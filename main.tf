#https://github.com/duo-labs/cloudmapper

/*
instancia ec2
instancia db
almancenamiento instancia 100 gb
*/

provider "aws" {
  region = var.region
}

module "umg_vpc" {
    source                  = "./modules/vpc"
    vpc_cidr                = "10.0.0.0/16"
    public_subnets_cidr     = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets_cidr    = ["10.0.3.0/24", "10.0.4.0/24"]
    azs                     = ["us-east-2a", "us-east-2b"]
    prefix_name             = var.prefix_name
}

module "umg_s3" {
    source                  = "./modules/s3"
    bucket_name             = var.bucket_name
    path_folder_content     = "./src/"
}

module "umg_ec2_a_s3" {
    source                  = "./modules/ec2_a_s3"
    prefix_name             = var.prefix_name
    bucket_name             = var.bucket_name
}

module "umg_alb_asg" {
    source               = "./modules/alb_asg"
    webserver_port       = 80
    webserver_protocol   = "HTTP"
    instance_type        = "t2.micro"
    private_subnet_ids   = module.umg_vpc.private_subnet_ids
    public_subnet_ids    = module.umg_vpc.public_subnet_ids
    role_profile_name    = module.umg_ec2_a_s3.name
    min_instance         = 2
    desired_instance     = 2
    max_instance         = 3
    ami                  = data.aws_ami.ubuntu-ami.id
    path_to_public_key   = "C:/Users/David-PC/.ssh/ec2.pub"
    vpc_id               = module.umg_vpc.vpc_id
    prefix_name          = var.prefix_name
    user_data = <<-EOF
      #!/bin/bash
      sudo apt-get update -y
      sudo apt-get install -y apache2 awscli mysql-client php php-mysql
      sudo systemctl start apache2
      sudo systemctl enable apache2
      sudo rm -f /var/www/html/index.html
      sudo aws s3 sync  s3://${var.bucket_name}/ /var/www/html/
      mysql -h ${module.umg_rds.host} -u ${module.umg_rds.username} -p${var.db_password} < /var/www/html/articles.sql
      sudo sed -i 's/##DB_HOST##/${module.umg_rds.host}/' /var/www/html/db-config.php
      sudo sed -i 's/##DB_USER##/${module.umg_rds.username}/' /var/www/html/db-config.php
      sudo sed -i 's/##DB_PASSWORD##/${var.db_password}/' /var/www/html/db-config.php      
    EOF   
}

module "umg_rds" {
  source                   = "./modules/rds"
  webserver_sg_id          = module.umg_alb_asg.webserver_sg_id
  prefix_name              = var.prefix_name
  private_subnet_ids       = module.umg_vpc.private_subnet_ids
  storage_gb               = 5
  vpc_id                   = module.umg_vpc.vpc_id
  mysql_version            = "8.0.23"
  mysql_instance_type      = "db.t2.micro"
  db_name                  = "blog"
  db_username              = "root"
  db_password              = "umgcoatepeque123"
  is_multi_az              = true
  storage_type             = "gp2"
  backup_retention_period  = 1
}

module "umg_cloudwatch_cpu_alarm" {
  source                 = "./modules/cloudwatch_cpu_alarms"
  prefix_name              = var.prefix_name
  min_cpu_percent_alarm  = 10
  max_cpu_percent_alarm  = 20 //cambiarlo a 12 para prueba de estres
  asg_name               = module.umg_alb_asg.asg_name
}
