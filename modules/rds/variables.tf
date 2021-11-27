variable "prefix_name" {}

variable "vpc_id" {}

variable "private_subnet_ids" {
	type = list
}

variable "webserver_sg_id" {
  type        = list
  description = "security group id para los servidores web" 
}

variable "storage_gb" {
	description = "cuantos gigas de almacenamiento se va a asignar"
  	default     = 5
}

variable "mysql_version" {
	default = "8.0.23"
}

variable "mysql_instance_type" {
	description = "tipo de instancia para la base de datos"
	default     = "db.t2.micro"
}

variable "db_name" {
	description = "nombre de la base de datos"
}

variable "db_username" {
	description = "usuario de la base de datos"
	default     = "root"
}

variable "db_password" {
	description = "contraseña de la base de datos"
	default     = "umgcoatepeque123"
}

variable "is_multi_az" {
	description = "usar verdadero para tener alta disponibilidad"
	default = false
}

variable "storage_type" {
	description = "tipo de almacenamiento para la base de datos"
	default = "gp2"
}


variable "backup_retention_period" {
	description = "cuanto tiempo se mantendran las copias de seguridad (30 max) ?"
	default     = 1
}

