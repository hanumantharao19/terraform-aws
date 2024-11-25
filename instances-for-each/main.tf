provider "aws" {
  region = var.region
}

resource "aws_instance" "instance" {
  for_each = toset(var.instaces-names)
  ami = var.mhr-ami
  instance_type = var.mhr-instance-type

  tags = {
    Name = each.key
  }
}