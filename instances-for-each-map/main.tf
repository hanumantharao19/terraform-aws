provider "aws" {
  region = var.region
}

resource "aws_instance" "instance" {
  for_each = var.instances
  ami = each.value.ami
  instance_type = each.value.instance_type
  availability_zone  =  each.value.az

  tags = {
    Name = each.value.name
  }
}