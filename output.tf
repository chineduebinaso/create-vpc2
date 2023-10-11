#output "vpc_id" {
#description = "The ID of the VPC"
# value       = module.vpc.vpc_id
#}

#output "vpc_arn" {
#description = "The ARN of the VPC"
# value       = module.vpc.vpc_arn
#}

#output "vpc_cidr_block" {
#description = "The CIDR block of the VPC"
# value       = module.vpc.vpc_cidr_block
#}

#output "default_security_group_id" {
# description = "The ID of the security group created by default on VPC creation"
#value       = module.vpc.default_security_group_id

#}

# Declare the IAM role for the EKS cluster
resource "aws_iam_role" "demo" {
  name = "eks-cluster-demo"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


# Declare the IAM role for EKS nodes
resource "aws_iam_role" "nodes" {
  name = "eks-nodes-demo"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Declare the IAM role for EKS nodes

output "private" {
  value = aws_subnet.private.*.id
}


output "public" {
  value = aws_subnet.public.*.id
}

output "node_role" {
  value = aws_iam_role.demo.arn
}

output "demo_role" {
  value = aws_iam_role.nodes.arn
}

output "vpc_id" {
  value = aws_vpc.main.id
}