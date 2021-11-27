variable "prefix_name" {}

variable "vpc_id" {}

variable "private_subnet_ids" {
  type = list
}

variable "public_subnet_ids" {
  type = list
}

variable "webserver_port" {
	default = 80
}

variable "webserver_protocol" {
	default = "HTTP"
}

variable "user_data" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "role_profile_name" {}


variable "min_instance" {
  description = "numero de instancias minimas para el grupo de autoescalado"
  default     = 1
}

variable "desired_instance" {
 description = "numero de instancias con las que inicia el grupo de autoescalado"
  default     = 2
}

variable "max_instance" {
  description = "numero de instancias maximas para el grupo de autoescalado"
  default     = 4
}

variable "ami" {}

variable "path_to_public_key" {
  description = "ruta de la llave publica que se almacenará en las instancias"
}