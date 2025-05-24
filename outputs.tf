output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
value = aws_subnet.public[*].id
}

output "private_subnets" {
value = aws_subnet.private[*].id
}

output "secretsmanager endpoint" {
value = aws_vpc_endpoint.secretsmanager.id
}

# output "vpc_nat" {
#   description = "The NAT Gateway ID"
#   value       = aws_nat_gateway.nat.id
# }

# output "vpc_eip" {
#   description = "The Elastic IP associated with NAT"
#   value       = aws_eip.nat.id
# }


# output "igw_id" {
#   description = "The Internet Gateway ID"
#   value       = aws_internet_gateway.igw.id
# }
