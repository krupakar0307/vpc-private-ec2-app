### Private VPC and ec2 deployed in private subnets. 

This Repo. consists of VPC and ec2 terraform configuration files.

The goal is to create an ec2 instance in private subnets and attach a internet-facing loadbalance to access an application.
where application was deployed in ec2-instance under private subnets.

## VPC 
This will create VPC with 2 private and public subnets along with IGW, NAT and Routers.

## EC2
This ec2 instance is privsioned in private subnets, where it doesn't have Internet, it will have NAT gatway attached to this subnets
to serve traffic from ec2 to outside. 
## Loadbalancer

Here loadbalancer will be provisioned in public subnets, by default intenet-facing LBs will create in public subnet and attach target groups (ec2) to LB.


### How to use :

1- Clone the code.
2- set aws credentials.
3- Do `terraform init` and update your inputs like region, subnets. (Here variables.tf is not used atm, will update soon), apply   `terraform plan` and apply it.
