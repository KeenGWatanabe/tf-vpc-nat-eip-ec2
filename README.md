This VPC is deploy for ECS containing the taskmgr app
# branch:
`secrets`: no EC2
`main`: has EC2

![alt text](/images/image.png)
networking diagram
https://app.diagrams.net/?splash=0#G10SF9Ql_S8yiikoBHy1MIR5iLKDDhCGOZ#%7B%22pageId%22%3A%22Ht1M8jgEwFfnCIfOTk4-%22%7D
# LATEST OUTPUT(20250622am):
# Outputs:

private_subnets = [
  "subnet-0df485dc22350894b",
  "subnet-09dd6aad1a79c6766",
]
public_subnets = [
  "subnet-0687a71703ee4c62a",
  "subnet-021f64fbfa79f0f0c",
]
secretsmanager_endpoint = "vpce-09bf2152745997d44"
vpc_eip = "eipalloc-04f545893277ce1ec"
vpc_id = "vpc-09d76b3df51d9aaa3"
vpc_nat = "nat-0db6755e35670ec72"


