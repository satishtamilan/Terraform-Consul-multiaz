# Terraform-Consul-multiaz
This repo contains a set of modules in the modules folder for deploying a Consul cluster on AWS using Terraform

# Consul AWS Module

This repo contains a set of modules in the [modules folder](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules) for deploying a [Consul](https://www.consul.io/) cluster on 
[AWS](https://aws.amazon.com/) using [Terraform](https://www.terraform.io/). Consul is a distributed, highly-available 
tool that you can use for service discovery and key/value storage. A Consul cluster typically includes a small number
of server nodes, which are responsible for being part of the [consensus 
quorum](https://www.consul.io/docs/internals/consensus.html), and a larger number of client nodes, which you typically 
run alongside your apps:

![Overall Architecture ](https://d1.awsstatic.com/partner-network/QuickStart/datasheets/hashicorp-consul-on-aws-architecture.93ab51b00fdcd07e763f73b6e38c47329c7579ad.png?raw=true)

## How to use this Module

This repo has the following folder structure:

* [modules](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules): This folder contains several standalone, reusable, production-grade modules that you can use to deploy Consul.
* [examples](https://github.com/hashicorp/terraform-aws-consul/tree/master/examples): This folder shows examples of different ways to combine the modules in the `modules` folder to deploy Consul.
* [test](https://github.com/hashicorp/terraform-aws-consul/tree/master/test): Automated tests for the modules and examples.
* [root folder](https://github.com/hashicorp/terraform-aws-consul/tree/master): The root folder is *an example* of how to use the [consul-cluster module](https://github.com/hashicorp/terraform-aws-consul/tree/master/modules/consul-cluster) 
  module to deploy a [Consul](https://www.consul.io/) cluster in [AWS](https://aws.amazon.com/).

  You can store your AWS Access Keys in a Credentials File which lives in ~/.aws/credentials

## How to Install 

The prerequisites are :

* [AWS CLI](https://aws.amazon.com/cli/): The AWS Command Line Interface (CLI) is a unified tool to manage your AWS service.
* [PACKER ](https://www.packer.io/): HashiCorp Packer is easy to use and automates the creation of any type of machine image
* [Terraform ](https://www.terraform.io/): HashiCorp Terraform enables you to safely and predictably create, change, and improve infrastructure.
* Install the latest version of [Go](https://golang.org/).
* Install [dep](https://github.com/golang/dep) for Go dependency management.

$ aws configure

```
AWS Access Key ID: 

AWS Secret Access Key: 

Default region name [None]: us-west-2

Default output format [None]: json

It also stores the other settings you entered in ~/.aws/config:
```

Package the Consul AMI

```sh
$ Packer validate consul.json
$ Packer build consul.json
```
It will pick all the configurations specified in the consul.json and provision 2 AMI one is AMAZON LINUX and Ubuntu.

Configure the Terraform.tfvars:
```
AMI_ID (Any specific AMI ID to be used)

cluster_name  (cluster Name)

num_server (Number of the servers)

num_clients (Number of the clients)

cluster_tag_key (Cluster Tags)

ssh_key_name (Create an ssh key)

VPC_ID (VPC Id if it needs to be created in particular VPC. By default it will spinup in default VPC)

Availability_Zones { Array of zones which the Instance need to spinup}.
```
## Running the Application:

```sh
terraform init
terraform plan
terraform apply
```

## Access the Application:

Http://consulserverpublicip:8500/

You can notice the consul server will discover the consul nodes with the agents Installed and you can see the discovered nodes.

## Running the tests

### One-time setup

Download Go dependencies using dep:
```
cd test
dep ensure
```
### Run all the tests

```bash
cd test
go test -v -timeout 60m
```

### Run a specific test

To run a specific test called `TestFoo`:

```bash
cd test
go test -v -timeout 60m -run TestFoo
```

### Maintainance:

After setting up your first cluster and nodes, it is an ideal time to make sure your cluster is healthy.

### Consul health:

* Transaction timing  
* Autopilot 
* Garbage collection

### Server health:

* File descriptors
* CPU usage
* Network activity
* Disk activity
* Memory usage


More Information on Collecting the Metrics, Telemetry, clearing garbage collection is here.

https://learn.hashicorp.com/consul/day-2-operations/monitoring.

## Cost Calculator:

https://calculator.s3.amazonaws.com/index.html#r=IAD&s=EC2&key=files/calc-932180febaddeb766005975f8dd56784ee2ec5c3&v=ver20190604sQ
