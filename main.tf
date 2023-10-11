# Private subnets


resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "bootcampvpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
 tags = {
    Name = "igw"
  }
}



resource "aws_eip" "nat" {
  vpc   = true
  count = length(var.public_cidr)

}
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

}



resource "aws_subnet" "private" {
  count             = length(var.private_cidr)
  cidr_block        = element(var.private_cidr, count.index)
  availability_zone = element(var.availability_zone, count.index)
  vpc_id            = aws_vpc.main.id


  tags = {
    Name                        = "private"
    "kubernetes.io/role/elb"    = "1"
    "kubernete.io/cluster/demo" = "owned"

  }
}



# Public VPCs
resource "aws_subnet" "public" {
  count                   = length(var.public_cidr)
  cidr_block              = element(var.public_cidr, count.index)
  availability_zone       = element(var.availability_zone, count.index)
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  #enable_nat_gateway      = true
  #single_nat_gateway      = true
  #enable_dns_hostnames    = true


  tags = {
    Name                        = "public"
    "kubernetes.io/role/elb"    = "1"
    "kubernete.io/cluster/demo" = "owned"
  }
}

#module "vpc" {
#source  = "terraform-aws-modules/vpc/aws"
# version = "5.1.2"
#}