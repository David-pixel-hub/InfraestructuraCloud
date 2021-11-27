variable "prefix_name" {}

variable "max_cpu_percent_alarm" { //NO SE USAN, SE DEFINE EN MAIN PRINCIPAL
	description = "porcentaje de uso de CPU para activar el escalado hacia arriba"
	default 	= 80
}

variable "min_cpu_percent_alarm" {
	description = "porcentaje de uso de CPU para activar el escalado hacia abajo"
	default 	= 25
}

variable "asg_name" {
	description = "nombre del ASG para agregar o reducri instancias ec2"
	default 	= "alrma-autoescalado"
}