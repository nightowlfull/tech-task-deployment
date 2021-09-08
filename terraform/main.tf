resource "aws_vpc" "t_task" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)  
  vpc_id                  = aws_vpc.t_task.id
  cidr_block              = element(concat(var.public_subnets, [""]), count.index)
  availability_zone       = element(concat(var.azs, [""]), count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project}-public-${count.index}"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.t_task.id  

tags = {
    Name = "${var.project}-rt"
  }

}

resource "aws_route" "public_igw_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.t_task.id  

timeouts {
    create = "5m"
  }

}
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)  
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id

}

resource "aws_internet_gateway" "t_task" {
  vpc_id = aws_vpc.t_task.id  
  tags = {
    Name = "${var.project}-igw"
  }

}


### Security Group 

resource "aws_security_group" "default_public" {
  name        = "${var.project}_default_public_sg"
  description = "${var.project} default public SG"
  vpc_id      = aws_vpc.t_task.id  

ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "VPN IP"
  }  

ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow http access"
  }  

ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Custom TCP access"
  }


egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  

tags = {
    Name = "${var.project}_public_sg"
  }
}



##### EC2 instance 

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.test-task.id
  allocation_id = aws_eip.task.id
}


resource "aws_instance" "test-task" {
  ami                         = "ami-02fe94dee086c0c37"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = true
  key_name                    = "${var.key_pair_name}"
  security_groups             = ["${aws_security_group.default_public.id}"]
  subnet_id                   = "${aws_subnet.public[0].id}"
  tags = {
    Name        = var.project
    Description = "Managed by terraform"
  }

provisioner "local-exec" {

## For EC2 attached to Elastic Public IP, It takes 10-15 seconds that's a reason we are using sleep command.
command = "sleep 15 && echo ${aws_eip.task.public_ip} > ../PUBLIC_IP.TXT"

}

}

resource "aws_eip" "task" {
#  depends_on = ["aws_instance.test-task"]
#  instance = "${aws_instance.test-task.id}"
  vpc = true
}

