provider "aws"{
    region = var.region_var
}


resource "aws_vpc" "devops106_dungureanu_terraform_vpc_tf"{
    cidr_block = "10.201.0.0/16"
    tags ={
        Name = "devops106_dungureanu_terraform_vpc"
    }
}


resource "aws_subnet" "devops106_dungureanu_terraform_subnet_app_webserver_tf"{
    vpc_id = local.vpc_id_var
    cidr_block = "10.201.1.0/24"
    tags ={
        Name = "devops106_dungureanu_app_subnet"
    }
}


resource "aws_subnet" "devops106_dungureanu_terraform_subnet_db_webserver_tf"{
    vpc_id = local.vpc_id_var
    cidr_block = "10.201.2.0/24"
    tags ={
    Name = "devops106_dungureanu_db_subnet"
    }
}


resource "aws_internet_gateway" "devops106_dungureanu_terraform_ig_tf"{
    vpc_id = local.vpc_id_var
    tags = {
    Name = "devops106_dungureanu_terraform_ig"
    }
}


resource "aws_route_table" "devops106_dungureanu_terraform_rt_public_tf"{
    vpc_id = local.vpc_id_var

    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.devops106_dungureanu_terraform_ig_tf.id

    }

    tags = {
        Name = "devops106_dungureanu_terraform_rt_public"
    }
}


resource "aws_route_table_association" "devops106_dungureanu_terraform_rt_assoc_app_public_webserver_tf"{
    subnet_id = aws_subnet.devops106_dungureanu_terraform_subnet_app_webserver_tf.id
    route_table_id = aws_route_table.devops106_dungureanu_terraform_rt_public_tf.id
}

resource "aws_route_table_association" "devops106_dungureanu_terraform_rt_assoc_db_public_webserver_tf"{
    subnet_id = aws_subnet.devops106_dungureanu_terraform_subnet_db_webserver_tf.id
    route_table_id = aws_route_table.devops106_dungureanu_terraform_rt_public_tf.id
}


resource "aws_network_acl" "devops106_dungureanu_terraform_nacl_app_public_tf"{
    vpc_id = local.vpc_id_var

    ingress {
        rule_no = 100
        from_port = 22
        to_port = 22
        cidr_block = "0.0.0.0/0"
        protocol = "tcp"
        action = "allow"
    }

    ingress {
        rule_no = 200
        from_port = 27017
        to_port = 27017
        cidr_block = "0.0.0.0/0"
        protocol = "tcp"
        action = "allow"
    }

    ingress {
        rule_no = 10000
        from_port = 1024
        to_port = 65535
        cidr_block = "0.0.0.0/0"
        protocol = "tcp"
        action = "allow"
    }


    egress {
        rule_no = 100
        from_port = 80
        to_port = 80
        cidr_block = "0.0.0.0/0"
        protocol = "tcp"
        action = "allow"
    }

    egress {
        rule_no = 200
        from_port = 443
        to_port = 443
        cidr_block = "0.0.0.0/0"
        protocol = "tcp"
        action = "allow"
    }

    egress {
        rule_no = 10000
        from_port = 1024
        to_port = 65535
        cidr_block = "0.0.0.0/0"
        protocol = "tcp"
        action = "allow"
    }

    subnet_ids = [aws_subnet.devops106_dungureanu_terraform_subnet_app_webserver_tf.id]

    tags={
        Name = "devops106_dungureanu_terraform_nacl_app_public"
    }
}

resource "aws_network_acl" "devops106_dungureanu_terraform_nacl_public_db_tf"{
    vpc_id = local.vpc_id_var

    ingress {
        rule_no = 100
        from_port = 22
        to_port = 22
        cidr_block = "0.0.0.0/0"
        protocol = "tcp"
        action = "allow"
    }

    ingress {
        rule_no = 200
        from_port = 27017
        to_port = 27017
        cidr_block = "0.0.0.0/0"
        protocol = "tcp"
        action = "allow"
    }

    ingress {
        rule_no =10000
        from_port = 1024
        to_port = 65535
        cidr_block = "0.0.0.0/0"
        protocol = "tcp"
        action = "allow"
    }

    egress {
        rule_no =100
        from_port = 80
        to_port = 80
        cidr_block = "0.0.0.0/0"
        protocol = "tcp"
        action = "allow"
    }

    egress{
        rule_no =200
        from_port = 443
        to_port = 443
        cidr_block = "0.0.0.0/0"
        protocol = "tcp"
        action = "allow"
    }

    egress{
        rule_no =10000
        from_port = 1024
        to_port = 65535
        cidr_block = "0.0.0.0/0"
        protocol = "tcp"
        action = "allow"
    }
    subnet_ids = [aws_subnet.devops106_dungureanu_terraform_subnet_db_webserver_tf.id]

    tags={
        Name = "devops106_dungureanu_terraform_nacl_db_public"
    }
}


resource "aws_security_group" "devops106_dungureanu_terraform_sg_app_webserver_tf"{
    name = "devops106_dungureanu_terraform_app_sg"
    vpc_id = local.vpc_id_var

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress{
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }


  tags ={
    Name = "devops106_dungureanu_terraform_sg_app_webserver"
  }
}


resource "aws_security_group" "devops106_dungureanu_terraform_sg_db_webserver_tf"{
    name = "devops106_dungureanu_terraform_db_sg"
    vpc_id = local.vpc_id_var

    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        from_port = 27017
        to_port = 27017
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress{
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags ={
    Name = "devops106_dungureanu_terraform_sg_db_webserver"
    }
}


resource "aws_instance" "devops106_dungureanu_terraform_webserver_app_tf" {
    ami = var.ubuntu_20_04_ami_id_var
    instance_type = var.instance_type_var
    key_name = var.key_name_var
    vpc_security_group_ids = [aws_security_group.devops106_dungureanu_terraform_sg_app_webserver_tf.id]

    subnet_id = aws_subnet.devops106_dungureanu_terraform_subnet_app_webserver_tf.id
    associate_public_ip_address = true

    # index starts at zero.
    count = 2

    # use counter to give it uniques tag name
    tags ={
        Name ="devops106_dungureanu_terraform_app_webserver_${count.index}"
    }

    connection {
        type = "ssh"
        user = "ubuntu"
        host = self.public_ip
        private_key = file(var.private_key_file_path_var)
    }

    provisioner "local-exec" {
        command = "echo mongodb://${aws_instance.devops106_dungureanu_terraform_webserver_db_tf.public_ip}:27017 > database.config"
    }

    provisioner "file" {
        source      = "/home/vagrant/host/terraform_spartan/database.config"
        destination = "/home/ubuntu/database.config"
    }

    provisioner "file" {
        source = "./init-scripts/docker-install.sh"
        destination = "/home/ubuntu/docker-install.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "bash /home/ubuntu/docker-install.sh"
        ]
    }

    provisioner "remote-exec" {
        inline = [
            "docker run -d -p 5000:5000 -v /home/ubuntu/database.config:/database.config leiungureanu/spartan_project_vagrant:1.2"
        ]
    }
}

resource "aws_instance" "devops106_dungureanu_terraform_webserver_db_tf" {
    ami                    = var.ubuntu_20_04_ami_id_var
    instance_type          = var.instance_type_var
    key_name               = var.key_name_var
    vpc_security_group_ids = [aws_security_group.devops106_dungureanu_terraform_sg_db_webserver_tf.id]

    subnet_id                   = aws_subnet.devops106_dungureanu_terraform_subnet_db_webserver_tf.id
    associate_public_ip_address = true

    tags = {
        Name = "devops106_dungureanu_terraform_db_webserver"
    }

    connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = self.public_ip
        private_key = file(var.private_key_file_path_var)
    }

    provisioner "file" {
        source = "./init-scripts/mongodb-install.sh"
        destination = "/home/ubuntu/mongodb-install.sh"
    }

    provisioner "remote-exec" {
    inline = [
        "bash /home/ubuntu/mongodb-install.sh"
    ]

  }

}