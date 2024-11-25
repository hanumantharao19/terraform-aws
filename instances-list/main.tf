provider "aws" {
  region = var.region
}

resource "aws_instance" "instance" {
  count = length(var.instaces-names)
  ami = var.mhr-ami
  instance_type = var.mhr-instance-type

  tags = {
    Name = var.instaces-names[count.index]
  }
}