
variable "tags" {

    default = {
        env = "dev"
        domain = "finance"
        owner = "hanu"
        Name = "dev-mhr-security-group"
    }
  
}

variable "ami" {
  default = "ami-0583d8c7a9c35822c"
}


variable "instance_type" {
  default = "t2.micro"
}