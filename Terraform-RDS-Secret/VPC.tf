#VPC creation
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.projectname}_vpc"
  }
}

#Creating a subnet-1
resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr1
  availability_zone       = var.availability_zone1
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.projectname}_subnet_1"
  }
}

#Creating a subnet-2
resource "aws_subnet" "subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr2
  availability_zone       = var.availability_zone2
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.projectname}_subnet_2"
  }
}

#Create IWG
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.projectname}_IGW"
  }
}

#Route Table creation
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.projectname}_route_table"
  }

}

#Associate the Route table with Subnet
resource "aws_route_table_association" "public_route1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "public_route2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.main.id
}

#Security Group
resource "aws_security_group" "main" {
  name        = "${var.projectname}_RDS_security_group"
  description = "${var.projectname}_RDS_Mysql"
  vpc_id      = aws_vpc.main.id


  tags = {
    Name = "${var.projectname}_RDS_security_group"
  }

  ingress {
    description = "${var.projectname}_RDS_allow_ingress_traffic"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = "true"
  }

  egress {
    description = "${var.projectname}_RDS_allow_egress_traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    self        = "true"
  }
}