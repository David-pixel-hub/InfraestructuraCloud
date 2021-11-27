variable "bucket_name" {
  description = "el nombre del buckeet debe ser unico en todo AWS"
}

variable "path_folder_content" {
  description = "agregar el contenido a la carpeta al bucket s3"
  default = "./src"
}