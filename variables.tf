# private key local path(vagrant path)
variable "private_key_file_path_var" {
  default = "/home/vagrant/.ssh/devops106_dungureanu.pem"
}

# authentication key name
variable "key_name_var" {
  default = "devops106_dungureanu"
}

# AWS instance type
variable "instance_type_var" {
  default = "t2.micro"
}

# OS image id
variable "ubuntu_20_04_ami_id_var" {
  default = "ami-08ca3fed11864d6bb"
}

variable "ubuntu_20_04_docker_ami_id_var" {
  default = "ami-0c36c885355cb6a49"
}

#Region name
variable "region_var" {
  default = "eu-west-1"
}

# VPC name extraction from terraform
locals {
  vpc_id_var     = aws_vpc.devops106_terraform_daniel_vpc_tf.id
  mongodb_ip_var = aws_instance.devops106_terraform_daniel_db_server_tf.public_ip
}
