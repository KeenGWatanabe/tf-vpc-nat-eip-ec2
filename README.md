This VPC is deploy for ECS containing the taskmgr app
# branch:
`secrets`: no EC2
`main`: has EC2

![alt text](/images/image.png)
networking diagram
https://app.diagrams.net/?splash=0#G10SF9Ql_S8yiikoBHy1MIR5iLKDDhCGOZ#%7B%22pageId%22%3A%22Ht1M8jgEwFfnCIfOTk4-%22%7D
# LATEST OUTPUT(20250825pm):
# Outputs:

private_subnets = [
  "subnet-01cc8e73c26738492",
  "subnet-075cff3f5a7e08397",
]
public_subnets = [
  "subnet-0e7594acacd779481",
  "subnet-0fce9162a3a35229e",
]
secretsmanager_endpoint = "vpce-067f98111d6f56976"
vpc_eip = "eipalloc-0af01f2304863971b"
vpc_id = "vpc-06ef77a9c78893200"
vpc_nat = "nat-04e1ca72da9c05bb3"


