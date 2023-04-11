# Infrastructure

## AWS Regions
**Primary**: us-east-2\
**Secondary**: us-west-1

## Servers and Clusters
- Deployed three EC2 instances named Ubuntu-Web in each region.
- Stored the AMI image used by the Ubuntu-Web EC2 instances in each region.
- Deployed two EC2 instances for the EKS cluster in each region.

### Table 1.1 Summary

| Asset | Purpose | Size | Qty | DR |
| --- | --- | --- | --- | --- |
| EC2 Instances (Web server) | Application virtual machines hosting e-commerce site | t3.micro | 3 | Deployed in Primary and Secondary AWS regions |
| EKS Cluster | Kubernetes cluster hosting monitoring stack | t3.medium | 2 | Deployed in Primary and Secondary AWS regions |
| VPC | Virtual network | /16 | 1 | Deployed in Primary and Secondary AWS regions, across multiple availability zones |
| ALB | Application load balancer |  | 1 | Deployed in Primary and Secondary AWS regions |
| RDS Cluster | Managed relational database | db.t2.small | 2 | Deployed in Primary and Secondary AWS regions, across multiple availability zones |
| S3 Bucket | Object storage for Terraform profile |  | 2 | Deployed in two regions |
| IAM Roles | AWS identity with permission policies for EKS cluster and worker nodes |  | 2 | Deployed in two regions for DR |
| Subnets | Range of IP addresses in VPC for launching AWS resources |  | 3 | Deployed in every Availability Zone of two regions for DR |
| AMI | EC2 instance image for web servers |  | 1 | Created in two regions |
| Key pair | Security credentials for connecting to EC2 instances |  | 2 | Created in two regions |
| Prometheus/Grafana | Monitoring stack |  | 1 | Deployed in Primary and Secondary AWS regions |
| Security Group | Configuration virtual firewall rules for EC2 instances, EKS nodes and RDS nodes |  | 3 | Deployed in Primary and Secondary AWS regions for DR |
| EC2 Instances (EKS cluster) | EC2 instances for EKS cluster worker nodes | t3.medium | 2 | Deployed in Primary and Secondary AWS regions for DR |
| RDS Cluster | Managed relational database | db.t2.small | 2 | Deployed in Primary and Secondary AWS regions, across multiple availability zones |


### Descriptions

- **VPC:** We have set up a virtual private cloud (VPC) network using a Class B address range with a /16 CIDR notation. There is one VPC network available in each AWS region, and each VPC network has subnets for both public and private usage in every availability zone for increased redundancy and reliability.
- **AMI Images:** AMI images hold the application executable and must be created and stored in both regions, with copying from the us-east-1 region.
- **EC2:** Create EC2 instances for the web server in every availability zone of the region.
- **Keypairs:** Key pair creation is required in both regions.
- **RDS Cluster:** Deploying 2 RDS clusters: primary in us-east-2 region with 1 write and 1 read instance, and secondary in us-west-1 region with 2 read instances and replication from primary cluster. Backups are set to 5 days and both clusters have additional redundancy from availability zones.

## DR Plan
### Pre-Steps:
- Create and configure an S3 bucket for terraform state.
- Create AMI image.
- Create private Keypair named "udacity".
- Deploy the VPC, Application Load Balancer (ALB), Security groups, EC2 instances web servers and EKS cluster to another region.
- Configure a secondary RDS cluster in us-west-1 region with replication from the primary RDS cluster in us-east-2 region.
- Code from monitoring stack like: prometheus configuration, Grafana dashboard and alerting; must be stored in a git repository so that in case of failure replicate the same monitoring configuration.
- Confirm the availability of the Terraform code in the IaC.
- Verify that the aws_ami is available in the secondary region.
- Set up a DR S3 bucket in the secondary region to use as a backend.
- Check that both aws_ami and S3 bucket have been defined.
- Deploy the resources in the secondary region by running terraform apply from the ./zone2 directory and following the prompts.
- Verify the health of the RDS cluster and AWS resources in the AWS portal.


## Steps:
- ### To promote a replica in a secondary region to become the primary RDS cluster:
        + Stop RDS instances individually in primary RDS cluster and wait around 2 minutes for them to stop.
        + In the secondary region, promote the RDS cluster to become a Regional cluster.
        + Create a direct client connection point to access the RDS cluster promoted as primary, as well as the new writer node and replica node.
        + Enable a direct access point to the Flask application to the ALB that balances traffic to the secondary region with the replicated RDS cluster in case of failure.
        + The application must be able to connect and be accessible to the database through DNS/Route 53.
- ### To failover the application to the secondary region:
        + Configure the AWS Route 53 DNS service to provide a DNS name that can point to the load balancers within both regions.
        + Point the DNS to the secondary region.
        + Manually failover the RDS cluster as described above.
        + Automatically failover the RDS cluster by health checks.
