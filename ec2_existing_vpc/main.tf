provider "aws" {
    region = "us-east-1"
}
resource "aws_security_group" "mhr-dev-sg" {
vpc_id = "vpc-04906b5f040a8669b"
 name = "dev-mhr-security-group"
 ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}
resource "aws_key_pair" "instance" {
  key_name   = "dev-mhr-instance-key"  # Replace with your desired key name
  public_key = file("~/.ssh/id_rsa.pub")  # Replace with the path to your public key file
}
resource "aws_instance" "server" {
  ami                    =  var.ami 
  instance_type          = var.instance_type
  key_name      = aws_key_pair.instance.key_name
  vpc_security_group_ids = [aws_security_group.mhr-dev-sg.id]
  subnet_id              = "subnet-0f9331219fd4cc718"
  tags = var.tags
  associate_public_ip_address = true

  
connection {
    type        = "ssh"
    user        = "ec2-user"  # Replace with the appropriate username for your EC2 instance
    private_key = file("~/.ssh/id_rsa")  # Replace with the path to your private key
    host        = self.public_ip
  }
provisioner "file" {
  source      = "index.html"
  destination = "/home/ec2-user/index.html"

}
provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",                # Update the package index
      "sudo yum install -y httpd",         # Install the HTTPD server
      "sudo systemctl start httpd",        # Start the HTTPD service
      "sudo systemctl enable httpd",       # Enable HTTPD to start on boot
      "echo '<h1>Hello, Terraform!</h1>' | sudo tee /var/www/html/index.html"  # Create a test page
    ]



 }

}