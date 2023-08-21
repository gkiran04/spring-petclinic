resource "aws_vpc" "myapp-vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "myapp-vpc"
    }
}

resource "aws_subnet" "myapp-public-1" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "myapp-sub-pub-1"
    }
}

resource "aws_subnet" "myapp-public-2" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true

    tags = {
        Name = "myapp-sub-pub-2"
    }
}

resource "aws_subnet" "myapp-public-3" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1c"
    map_public_ip_on_launch = true

    tags = {
        Name = "myapp-sub-pub-3"
    }
}

resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc.id

    tags = {
        Name = "myapp-igw"
  }
}

resource "aws_route_table" "myapp-rt" {
  vpc_id = aws_vpc.myapp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  
  tags = {
    Name = "myapp-rt"
  }
}

resource "aws_route_table_association" "myapp-rta-1" {
  subnet_id      = aws_subnet.myapp-public-1.id
  route_table_id = aws_route_table.myapp-rt.id
}

resource "aws_route_table_association" "myapp-rta-2" {
  subnet_id      = aws_subnet.myapp-public-2.id
  route_table_id = aws_route_table.myapp-rt.id
}

resource "aws_route_table_association" "myapp-rta-3" {
  subnet_id      = aws_subnet.myapp-public-3.id
  route_table_id = aws_route_table.myapp-rt.id
}