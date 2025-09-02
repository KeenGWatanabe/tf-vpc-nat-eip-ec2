Of course! This is an excellent best practice for AWS account management. Let's break this down into two parts: creating a cleanup tool and understanding default VPC duplication.

---

### Part 1: Creating an AWS Cleanup Tool

A cleanup tool typically identifies and deletes unused or "orphaned" resources to save costs and improve security. You can build this with AWS CLI scripts, AWS SDKs (like Python/Boto3), or use third-party tools.

Here’s a structured approach:

#### 1. **Strategy: Use AWS CLI & Shell Scripts (Quickest Start)**

This is a simple, effective way to get started. You create a script that targets specific resources.

**Example Script Skeleton (`cleanup.sh`):**
```bash
#!/bin/bash
# Define the regions you want to clean up
REGIONS="us-east-1 us-west-2 eu-west-1" # Add your regions

for region in $REGIONS; do
    echo "Checking region: $region"

    # 1. Delete unused Elastic IPs (not associated with an instance)
    echo "Checking for unused EIPs in $region"
    eip_allocations=$(aws ec2 describe-addresses --region $region --query 'Addresses[?AssociationId==`null`].AllocationId' --output text)
    for allocation in $eip_allocations; do
        echo "Releasing unused EIP: $allocation"
        aws ec2 release-address --region $region --allocation-id $allocation
    done

    # 2. Delete unattached EBS volumes
    echo "Checking for unattached Volumes in $region"
    volume_ids=$(aws ec2 describe-volumes --region $region --filters Name=status,values=available --query 'Volumes[].VolumeId' --output text)
    for volume_id in $volume_ids; do
        echo "Deleting unattached volume: $volume_id"
        aws ec2 delete-volume --region $region --volume-id $volume_id
    done

    # 3. Terminate old EC2 instances (e.g., tagged with "temp" or older than 7 days)
    # echo "Terminating old instances..."
    # aws ec2 describe-instances --region $region --query 'Reservations[].Instances[?LaunchTime<`2023-01-01`].InstanceId' --output text | xargs aws ec2 terminate-instances --region $region --instance-ids

    # 4. Delete empty S3 buckets (BE VERY CAREFUL)
    # echo "Listing buckets..."; aws s3api list-buckets --query 'Buckets[].Name'

done

echo "Cleanup completed for all specified regions."
```

**How to Run:**
1.  Save the script as `cleanup.sh`.
2.  Make it executable: `chmod +x cleanup.sh`
3.  Run it: `./cleanup.sh`

**Crucial Warning:** **Always test this in a non-production account first!** Uncomment the instance termination and bucket deletion lines only when you are 100% sure they are safe to run.

#### 2. **Advanced Strategy: Use Python with Boto3 (More Power & Control)**

For a more robust tool, use Python and the Boto3 library. This allows for better error handling, filtering, and logic.

**Example: Cleanup Python Script (`cleanup.py`)**
```python
import boto3
from botocore.exceptions import ClientError

def cleanup_region(region_name):
    """Cleans up resources in a specific region"""
    print(f"\n--- Cleaning up region: {region_name} ---")
    ec2 = boto3.resource('ec2', region_name=region_name)
    client = boto3.client('ec2', region_name=region_name)

    # 1. Unattached EBS Volumes
    volumes = ec2.volumes.filter(
        Filters=[{'Name': 'status', 'Values': ['available']}]
    )
    for volume in volumes:
        print(f"Deleting unattached volume: {volume.id}")
        try:
            volume.delete()
        except ClientError as e:
            print(f"Error deleting volume {volume.id}: {e}")

    # 2. Unused Elastic IPs
    addresses = client.describe_addresses()
    for address in addresses['Addresses']:
        if 'AssociationId' not in address:
            print(f"Releasing unused EIP: {address['AllocationId']}")
            try:
                client.release_address(AllocationId=address['AllocationId'])
            except ClientError as e:
                print(f"Error releasing IP {address['AllocationId']}: {e}")

if __name__ == "__main__":
    regions = ['us-east-1', 'eu-west-1'] # Add your regions
    for region in regions:
        cleanup_region(region)
```
**Run it with:** `python3 cleanup.py`

#### 3. **Use Existing Tools (Quickest Option)**

Why reinvent the wheel? These are excellent open-source tools:
*   **AWS Nuke:** The most powerful and comprehensive tool. **WARNING: It is destructive!** It will delete EVERY resource in an account that isn't explicitly whitelisted in its config file. Perfect for cleaning entire accounts for disposal or testing.
*   **CloudMapper:** Originally for security auditing, it has functions to find unused resources.
*   **AWS Compute Optimizer:** An AWS service that recommends rightsizing and identifies unused resources.

---

### Part 2: Duplicating a Default VPC After Deletion

**The short answer is No, you cannot "duplicate" or "clone" a VPC from one region to another.** VPC IDs, subnet IDs, route table IDs, etc., are all unique to their region and cannot be transferred.

**The correct solution is to create a new *Default VPC* in the region where you deleted it.**

AWS provides a simple API call to do exactly this. It will create a new default VPC with the standard CIDR block (`172.31.0.0/16`), create a new internet gateway, attach it, and create public subnets in each Availability Zone.

**Using the AWS CLI:**
```bash
# This will create a new default VPC in the specified region
aws ec2 create-default-vpc --region us-west-1
```
**Output:**
```json
{
    "Vpc": {
        "CidrBlock": "172.31.0.0/16",
        "DhcpOptionsId": "dopt-12345678",
        "State": "pending",
        "VpcId": "vpc-0a1234567890abcdef",
        "OwnerId": "123456789012",
        "InstanceTenancy": "default",
        "Ipv6CidrBlockAssociationSet": [],
        "CidrBlockAssociationSet": [],
        "IsDefault": true
    }
}
```

That's it! AWS will handle all the underlying networking setup for you, just like it did the first time. The new default VPC will be functionally identical to the original one, just with new, unique resource IDs.

### Summary

1.  **Cleanup Tool:** Start with a simple shell script or use a powerful existing tool like **AWS Nuke** (with extreme caution).
2.  **Default VPC "Duplication":** Don't try to copy-paste VPCs. Use the `create-default-vpc` API command to generate a new, properly configured default VPC in any region where you need it.