variable "region" {
  default = "us-east-2"
}

variable "prefix_name" {
  default = "umgcoatepeque"
  # default = "devopssec"
}

variable "bucket_name" {
  default = "umgcoatepeque-s3-bucket-sistema-php"
}

variable "db_password" {
  default = "umgcoatepeque123"
}

data "aws_ami" "ubuntu-ami" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20200430"]
    }
    owners = ["099720109477"]
}