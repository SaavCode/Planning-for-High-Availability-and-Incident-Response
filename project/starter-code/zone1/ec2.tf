module "project_ec2" {
  source             = "./modules/ec2"
  ec2_instance_count = var.ec2_instance_count
  name               = local.name
  account            = data.aws_caller_identity.current.account_id
  aws_ami            = "ami-0bdad61fab7bf5a62"
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  vpc_id             = module.vpc.vpc_id
}
