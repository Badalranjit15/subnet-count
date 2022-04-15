/*=== Specify the provider and access details ===*/  
provider "aws" {
  region = var.region
  profile = "default"
}

data "aws_availability_zones" "all" {
  state = "available"
}

locals {
   subnet_count = var.subnet_count >= 1 ? var.subnet_count : length(data.aws_availability_zones.all.names)
}

/*=== Create a VPC to launch our resources ===*/ 
resource "aws_vpc" "my_vpc" {
  cidr_block                       = var.cidr_block
  enable_classiclink               = false
  enable_classiclink_dns_support   = false
  enable_dns_hostnames             = false
  enable_dns_support               = false
  tags                             = {
      "Name" = "var.vpc_name"
  }
}

/*=== Create a private subnet to launch our web-app-instances ===*/
resource "aws_subnet" "my_subnet_private" {
  vpc_id                   = aws_vpc.my_vpc.id
  count                    = var.enable_private_subnet == true ? local.subnet_count : 0
  cidr_block               = cidrsubnet(var.private_subnet, local.subnet_count, count.index)
  tags = { 
    Name = format("%s%d%s","private-",count.index,"-${aws_vpc.my_vpc.tags["Name"]}")
    type = "private" 
  }
  availability_zone       =  "${data.aws_availability_zones.all.names[count.index]}"
}


/*=== Create Private route table for private subnets ===*/# 
resource "aws_route_table" "my_private_RT" {
  vpc_id = aws_vpc.my_vpc.id
  tags = { 
    Name = "my_private_RT" 
  }
  depends_on        =  [aws_subnet.my_subnet_private]
}

/*===  ===*/
resource "aws_route_table_association" "private" {
  count             = length(aws_subnet.my_subnet_private) #!= 0 ? length(aws_subnet.my_subnet_private) : 0
  subnet_id         = "${aws_subnet.my_subnet_private[count.index].id}"
  route_table_id    =  aws_route_table.my_private_RT.id
  depends_on        =  [aws_subnet.my_subnet_private]
}

resource "aws_default_security_group" "default" {
  vpc_id = module.vpc.vpc_id

  # ingress {
  #   from_port = 0
  #   to_port   = 0
  #   protocol  = -1
  #   self      = true
  # }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
