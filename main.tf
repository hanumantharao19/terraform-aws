provider "aws" {
  region     = "us-west-2"
  access_key = "AKIAXZRCADIOMF6HWYMZ"
  secret_key = "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"
}

resource "aws_instance" "ramana" {
  ami                    = "ami-0800fc0fa715fdcfe"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ramana-sg.id]



tags = {
    Name = "ramanaserver"
  }
}
resource "aws_security_group" "ramana-sg" {
  name = "ramana-security"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
