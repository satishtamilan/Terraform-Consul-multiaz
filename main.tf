terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region              = "us-east-1"
}

data "aws_ami" "consul" {
  most_recent = true

  # If we change the AWS Account in which test are run, update this value.
  owners = ["562637147889"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "is-public"
    values = ["true"]
  }

  filter {
    name   = "name"
    values = ["consul-ubuntu-*"]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE CONSUL SERVER NODES
# ---------------------------------------------------------------------------------------------------------------------

module "consul_servers" {
  source = "./modules/consul-cluster"

  cluster_name  = "${var.cluster_name}-server"
  cluster_size  = var.num_servers
  instance_type = "t2.micro"
  spot_price    = var.spot_price

  # The EC2 Instances will use these tags to automatically discover each other and form a cluster
  cluster_tag_key   = var.cluster_tag_key
  cluster_tag_value = var.cluster_name

  ami_id    = "${var.ami_id == null ? data.aws_ami.consul.image_id : var.ami_id}"
  user_data = "${data.template_file.user_data_server.rendered}"

  vpc_id     = data.aws_vpc.default.id
  #subnet_ids = data.aws_subnet_ids.default.ids
  allowed_ssh_cidr_blocks = ["0.0.0.0/0"]

  availability_zones          = var.availability_zones

  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
  ssh_key_name                = var.ssh_key_name

  tags = [
    {
      key                 = "Environment"
      value               = "development"
      propagate_at_launch = true
    }
  ]
}


data "template_file" "user_data_server" {
  template = file("${path.module}/user-scripts/user-data-server.sh")

  vars = {
    cluster_tag_key   = var.cluster_tag_key
    cluster_tag_value = var.cluster_name
  }
}


module "consul_clients" {
  source = "./modules/consul-cluster"

  cluster_name  = "${var.cluster_name}-client"
  cluster_size  = var.num_clients
  instance_type = "t2.micro"
  spot_price    = var.spot_price

  cluster_tag_key   = "consul-clients"
  cluster_tag_value = var.cluster_name

  ami_id    = "${var.ami_id == null ? data.aws_ami.consul.image_id : var.ami_id}"
  user_data = "${data.template_file.user_data_client.rendered}"

  vpc_id     = data.aws_vpc.default.id
  #subnet_ids = data.aws_subnet_ids.default.ids

  allowed_ssh_cidr_blocks = ["0.0.0.0/0"]

    availability_zones          = var.availability_zones

  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
  ssh_key_name                = var.ssh_key_name
}


data "template_file" "user_data_client" {
  template = file("${path.module}/user-scripts/user-data-client.sh")

  vars = {
    cluster_tag_key   = var.cluster_tag_key
    cluster_tag_value = var.cluster_name
  }
}


data "aws_vpc" "default" {
  default = var.vpc_id == null ? true : false
  id      = "${var.vpc_id}"
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_region" "current" {
}

