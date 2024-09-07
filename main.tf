# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
 
}
 
 
//create ec2-instance
 
/*resource "aws_instance" "web_serv" {
  ami           = "ami-027d95b1c717e8c5d" #eu-west-2
  for_each = var.aws_instance_type
  key_name = "test"
  subnet_id =  aws_subnet.pub_subnet.id
  associate_public_ip_address = true
 
 
tags = {
    Name = "${local.company_name}-web_serv"
  }
 
}
 
 
 
//create ec2-instance
resource "aws_instance" "db_server" {
  ami           = "ami-027d95b1c717e8c5d" #eu-west-2
  instance_type = "t3.micro"
  key_name = "test"
  subnet_id = aws_subnet.priv_subnet.id
  associate_public_ip_address = true
 
  tags = {
    Name = "${local.company_name}-db_server"
  }
 
}
 
 
//create ec2-instance
resource "aws_instance" "app_server" {
  ami           = "ami-027d95b1c717e8c5d" #eu-west-2
  instance_type = "t3.micro"
  key_name = "test"
  subnet_id = aws_subnet.priv_subnet.id
  associate_public_ip_address = true
 
  tags = {
    Name = "${local.company_name}-app_server"
  }
 
}*/
 
// assigning static private ip address to network interface
resource "aws_network_interface" "ansible_network_interface" {
  count           = length(local.priv_ips)
  //count           = 3
  
  subnet_id       = aws_subnet.pub_subnet.id
  private_ips     = [local.priv_ips[count.index]]
  security_groups = [aws_security_group.ansible_sg.id]
  tags = {    
    Name = "${local.company_name}-ansible_network_interface"  
    }
   
    }
 
// create multiple instances with same public ip address
resource "aws_instance" "ansible_controller" {
  count                       = var.instance_count
  ami                         = "ami-05d929ac8893c382f"
  instance_type               = "t2.micro"
  key_name                    = "test_key"
  #associate_public_ip_address = true
  #vpc_security_group_ids      = [aws_security_group.ansible_sg.id]
 
  network_interface {    
    network_interface_id = aws_network_interface.ansible_network_interface[count.index].id
    device_index         = 0
  }
 
 
  tags = {
    Name = "Ansible-${count.index + 1}"
  }
}
 
// create vpc
 
resource "aws_vpc" "beneficient_vpc" {
  cidr_block       = "172.20.0.0/18"
  instance_tenancy = "default"
 
  tags = {
    Name = "${local.company_name}-vpc"
  }
}
 
 
//create subnet
resource "aws_subnet" "pub_subnet" {
  vpc_id     = aws_vpc.beneficient_vpc.id
  cidr_block = "172.20.16.0/20"
  availability_zone = "eu-west-2a"
  map_public_ip_on_launch = true
 
  tags = {
    Name = "${local.company_name}-pub_subnet"
  }
}
 
 
//create subnet
/*resource "aws_subnet" "priv_subnet" {
  vpc_id     = aws_vpc.teckwik_vpc.id
  cidr_block = "172.20.16.0/20"
  availability_zone = "eu-west-2b"
 
  tags = {
    Name = "${local.company_name}-priv_subnet"
  }
}*/
 
 
 
// create internet gateway
resource "aws_internet_gateway" "beneficient_igw" {
vpc_id = aws_vpc.beneficient_vpc.id
 
tags = {
   Name = "${local.company_name}-igw"
}
}
 
//create route table
resource "aws_route_table" "beneficient_rt" {
  vpc_id = aws_vpc.beneficient_vpc.id
 
  route {
    cidr_block = var.vpc_cidr_block
    gateway_id = aws_internet_gateway.beneficient_igw.id
  }
 
 
  tags = {
    Name = "${local.company_name}-rt"
  }
}
 
//associate subnet with route table
resource "aws_route_table_association" "beneficient_rt" {
  subnet_id      = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.beneficient_rt.id
}
 
 
// create security group
resource "aws_security_group" "ansible_sg" {
  name = "ansible_sg"
  vpc_id = aws_vpc.beneficient_vpc.id
 
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    //ipv6_cidr_blocks = ["::/0"]  
}
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    //ipv6_cidr_blocks = ["::/0"]
  }
}
 
 
 
 
 
 
 