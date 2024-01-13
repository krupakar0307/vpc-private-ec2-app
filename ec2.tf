####Fetch AMI_ID
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}

### create PUBLIC-ec2-instance-1

resource "aws_instance" "myEc2" {
  # count                = 1
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.public_subnet_1.id
  key_name             = aws_key_pair.myKeypair.key_name  
  availability_zone    = "ap-south-1a"
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "./metadata.sh"
    destination = "/home/ubuntu/metadata.sh"
  }
  provisioner "file" {
      source      = "~/.ssh/id_rsa"
      destination = "/home/ubuntu/id_rsa"
    }

  tags = {
    Name = "public-ec2(bastion)"
  }
}

####Private subnets
###
resource "aws_instance" "myEc2_private_1" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.private_subnet_1.id
  key_name             = aws_key_pair.myKeypair.key_name  
  availability_zone    = "ap-south-1a"
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }
  # provisioner "file" {
  #   source      = "./metadata.sh"
  #   destination = "/home/ubuntu/metadata.sh"
  # }

  tags = {
    Name = "private_ec2_1"
  }
}

# #######
resource "aws_instance" "myEc2_private_2" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.private_subnet_2.id
  key_name             = aws_key_pair.myKeypair.key_name  
  availability_zone    = "ap-south-1b"
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }
  # provisioner "file" {
  #   source      = "./metadata.sh"
  #   destination = "/home/ubuntu/metadata.sh"
  # }

  tags = {
    Name = "private_ec2_2"
  }
}

resource "aws_key_pair" "myKeypair" {
  key_name   = "test-ami"
  public_key = file("~/.ssh/id_rsa.pub")
}


###### security group

resource "aws_security_group" "my_sg" {
    name = "mysg"
    vpc_id = aws_vpc.vpc_dev.id
    ingress {
        description = "HTTP from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTP from SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks =  ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "my_Sg"
    }
}
