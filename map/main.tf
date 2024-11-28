provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "instance" {
    ami = var.instance_details["ami"]
    instance_type = lookup(var.instance_details, "instance_type", "t2.micro" )
}

variable "instance_details" {
    type = map(string)
    default = {
        ami = "ami-0583d8c7a9c35822c"
        instance_type = "t2.medium"
    }
  
}