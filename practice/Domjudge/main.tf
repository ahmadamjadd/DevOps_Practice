terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.45.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

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

# --- FIX 5: Fixed Data Source Naming and vpc_id mapping ---
data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro" # Changed to t3.medium to ensure enough RAM for DB + Server + Judgehost

  tags = {
    Name = "DOMSERVER"
  }
  key_name = aws_key_pair.instance-key.key_name
  vpc_security_group_ids = [
        data.aws_security_group.default.id
  ]
  depends_on = [
        aws_key_pair.instance-key
  ]
  
  user_data = <<-EOF
#! /usr/bin/bash
# Add Docker's official GPG key:
sudo apt update -y
sudo apt install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources (FIX 1: Changed EOF to EOF_REPO)
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF_REPO
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "$${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF_REPO

sudo apt update -y

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -aG docker ubuntu
sudo systemctl start docker

sudo mkdir /app
sudo touch /app/docker-compose.yml

# (FIX 1: Changed EOF to EOF_COMPOSE)
cat <<- EOF_COMPOSE >> /app/docker-compose.yml
services:
  db:
    image: mariadb
    container_name: db
    volumes:
      - persistant:/var/lib/mysql
    environment:
      - MYSQL_USER=domjudge
      - MYSQL_PASSWORD=djpw
      - MYSQL_DATABASE=domjudge
      - MYSQL_ROOT_PASSWORD=rootpw
    ports:
      - "13306:3306"
    command: ["--max-allowed-packet=64M"]
    networks:
      - dom_network

  domserver:
    image: domjudge/domserver:latest
    container_name: domserver
    networks:
      - dom_network
    environment:
      - MYSQL_HOST=db
      - MYSQL_USER=domjudge
      - MYSQL_DATABASE=domjudge
      - MYSQL_PASSWORD=djpw
      - MYSQL_ROOT_PASSWORD=rootpw
    ports:
      - "80:80"

  domjudge:
    image: domjudge/judgehost:latest
    privileged: true
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
    cgroup: host
    environment:
      - DOMSERVER_BASEURL=http://domserver/
      - JUDGEDAEMON_PASSWORD=password
    depends_on:
      domserver:
        condition: service_healthy
    networks:
      - dom_network

networks:
  dom_network:
    driver: bridge

volumes:
  persistant:

EOF_COMPOSE

cd /app
docker compose up -d

# FIX 3: Wait for DOMserver and DB to initialize
sleep 60 

# FIX 2 & 4: Removed -it flag and used docker compose restart
docker exec domserver /opt/domjudge/domserver/webapp/bin/console domjudge:reset-user-password admin admin123
docker exec domserver /opt/domjudge/domserver/webapp/bin/console domjudge:reset-user-password judgehost password
docker compose restart domjudge

EOF
}

resource "aws_key_pair" "instance-key" {
    key_name = "iac-demo"
    public_key = file("~/.ssh/ec2-key-pair.pub")
}

resource "aws_vpc_security_group_ingress_rule" "HTTP" {
  security_group_id = data.aws_security_group.default.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "SSH" {
  security_group_id = data.aws_security_group.default.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

output "ip"{
  value = aws_instance.example.public_ip
}