output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.main.id
}

output "vpc_nat" {
  description = "The NAT Gateway ID"
  value       = aws_nat_gateway.nat.id
}

output "vpc_eip" {
  description = "The Elastic IP associated with NAT"
  value       = aws_eip.nat.id
}


output "igw_id" {
  description = "The Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}
