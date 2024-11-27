vpc_name = "mhr-dev-vpc"
cidr ="10.1.0.0/16"
tags = {
    env = "dev"
    domain = "finance"
}
public_subnets = ["10.1.1.0/24","10.1.2.0/24","10.1.3.0/24"]
public_subnet_names = ["mhr-dev-pub-subnet-1","mhr-dev-pub-subnet-2","mhr-dev-pub-subnet-3"]
private_subnets = ["10.1.10.0/24","10.1.20.0/24","10.1.30.0/24"]
private_subnet_names = ["mhr-dev-private-subnet-1","mhr-dev-private-subnet-2","mhr-dev-private-subnet-3"]
azs = ["us-east-1a","us-east-1b","us-east-1c"]