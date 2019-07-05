# Sample terraform configuration to create VPC on AWS

## Prerequisites

- git
- terraform
- AWS subscription

## How to use

- Get the repo

```
https://github.com/achuchulev/terraform-aws-vpc.git
cd terraform-aws-vpc
```

- Create `terraform.tfvars` file

```
aws_access_key = "your_aws_access_key"
aws_secret_key = "your_aws_secret_key"
aws_region = "some_aws_region"

vpc_cidr_block = "some_vpc_cidr_block"
vpc_subnet_cidr_blocks = ["list_vpc_subnet_cidr_block(s)"]

vpc_tags = {
   Site = "site_name"
   Name = "vpc_name"
}
```


```
Note: VPC Security group that is created allows ssh (tcp port 22) and icmp echo request/reply inbound traffic.
```

- Initialize terraform and plan/apply

```
terraform init
terraform plan
terraform apply
```

- `Terraform apply` will:
  - create new VPC on specified AWS region
  - create subnet(s) for VPC
  - create Internet GW and route for the VPC
  - assosciate VPC main route table with subnet(s)
  
