provider "aws" {
  region = "us-east-1a"
}


#VPC
resource "aws_vpc" "my_fist_vpc"{
  cidr_block = "10.0.0.0/16"
  tags { Name = "my_first_vpc"}
}


#Security Group
resource "aws_security_group" "security_group" {
    vpc_id = aws_vpc.my_first_vpc.id
    name = "security_group"
    description = "Created by Terraform"

}
resource "aws_security_group_rule_ingress_rule" "allow_ingress"{
        from_port = 443
        to_port = 443
        ip_protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        security_group_id = aws_security_group.security_group_id
    }




#Subnet
resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.my_first_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
}
resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws_vpc.my_first_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
}
resource "aws_subnet" "private_subnet_1" {
    vpc_id = aws_vpc.my_first_vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1a"
}
resource "aws_subnet" "private_subnet_2" {
    vpc_id = aws_vpc.my_first_vpc.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "us-east-1b"
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_first_vpc.id

  tags = {
    Name = "igw"
  }
}

#Route Table
resource "aws_route_table" "public_route" {
    vpc_id = aws_vpc.my_first_vpc.id  
    route_table_id = aws_route_table.public_route.id

    tags = {
        Name = "Public-route-table"
     }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
  } 
     
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route.id
}
