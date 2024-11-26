region = "us-east-1"
instances = {
    "instance1" = {
    ami = "ami-0583d8c7a9c35822c"
    instance_type = "t2.micro"
    name = "dev-instance"
    az= "us-east-1a"
    }

    "instance2" = {
    ami = "ami-0583d8c7a9c35822c"
    instance_type = "t2.micro"
    name = "qa-instance"
    az= "us-east-1b"
    }

    "instance3" = {
    ami = "ami-0583d8c7a9c35822c"
    instance_type = "t2.medium"
    name = "prod-instance"
    az= "us-east-1c"
    }
}