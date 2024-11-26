variable "region" {
    type = string
    default = "us-east-1"
  
}

variable "instances" {
  type = map(object({
    ami = string
    instance_type = string
    name = string
    az= string
  }))
}