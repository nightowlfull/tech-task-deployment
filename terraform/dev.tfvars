project    = "test-task"
region     = "us-east-1"
cidr_block = "10.0.0.0/16"
public_subnets = ["10.0.32.0/20", "10.0.96.0/20", "10.0.160.0/20"]
azs            = ["us-east-1a", "us-east-1b", "us-east-1c"]
instance_type  = "t2.micro"
key_pair_name = "ec2-test-key"