# 1. Look up the Ubuntu AMI (Your data block is perfect!)
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# 2. Instance 1: The Public Web Server
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"                # Exact assignment specification
  subnet_id              = aws_subnet.public_1.id    # Placed in public subnet cleanly
  vpc_security_group_ids = [aws_security_group.web_sg.id] # Fixed argument
  key_name               = aws_key_pair.deployer.key_name

  # Inline user_data script to configure Apache
  user_data = <<EOF
#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
EOF

  tags = {
    Name = "Assignment4-EC2-1" # Exact assignment name requirement
  }
}

# 3. Instance 2: The Private Database Server
resource "aws_instance" "db_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"                # Exact assignment specification
  subnet_id              = aws_subnet.private_1.id   # Placed safely in private subnet
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.deployer.key_name

  tags = {
    Name = "Assignment4-EC2-2" # Clean, professional naming
  }
}