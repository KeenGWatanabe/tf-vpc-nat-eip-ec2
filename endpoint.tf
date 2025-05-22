# EXTRA : facilitate aws secrets mgr access

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.us-east-1.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private.id]  # Your private subnet(s)
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  private_dns_enabled = true  # Critical for DNS resolution
}

resource "aws_security_group" "vpc_endpoint" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]  # Allow only from your VPC
  }
}