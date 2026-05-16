# 1. The Security Group Wrapper
resource "aws_security_group" "web_sg" {
  name        = "devops-web-server-sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "devops-web-server-sg"
  }
}

# 2. Inbound Rule for HTTP (Port 80) from Everywhere
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp" # Must be tcp, not http
  to_port           = 80
}

# 3. Inbound Rule for SSH (Port 22) so you can connect from your terminal
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = "0.0.0.0/0" # In exams, 0.0.0.0/0 is standard for grading access
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# 4. Outbound Rule allowing your EC2 to fetch updates from the internet
resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # Represents all protocols and ports
}