provider "aws" {
  region = var.region_var
}


resource "aws_vpc" "devops106_terraform_daniel_vpc_tf" {
  cidr_block           = "10.203.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = {
    Name = "devops106_terraform_daniel_vpc"
  }
}


data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "devops106_terraform_daniel_subnet_app_webserver_tf" {
  vpc_id            = local.vpc_id_var
  cidr_block        = "10.203.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags              = {
    Name = "devops106_terraform_daniel_app_subnet"
  }
}

resource "aws_subnet" "devops106_terraform_daniel_subnet_app_webserver2_tf" {
  vpc_id            = local.vpc_id_var
  cidr_block        = "10.203.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags              = {
    Name = "devops106_terraform_daniel_app_subnet2"
  }
}

resource "aws_subnet" "devops106_terraform_daniel_subnet_db_webserver_tf" {
  vpc_id     = local.vpc_id_var
  cidr_block = "10.203.2.0/24"
  tags       = {
    Name = "devops106_terraform_daniel_db_subnet"
  }
}


resource "aws_internet_gateway" "devops106_terraform_daniel_ig_tf" {
  vpc_id = local.vpc_id_var
  tags   = {
    Name = "devops106_terraform_daniel_ig"
  }
}


resource "aws_route_table" "devops106_terraform_daniel_rt_public_tf" {
  vpc_id = local.vpc_id_var

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops106_terraform_daniel_ig_tf.id

  }

  tags = {
    Name = "devops106_terraform_daniel_rt_public"
  }
}


resource "aws_route_table_association" "devops106_terraform_daniel_rt_assoc_app_public_webserver_tf" {
  subnet_id      = aws_subnet.devops106_terraform_daniel_subnet_app_webserver_tf.id
  route_table_id = aws_route_table.devops106_terraform_daniel_rt_public_tf.id
}

resource "aws_route_table_association" "devops106_terraform_daniel_rt_assoc_app_public_webserver2_tf" {
  subnet_id      = aws_subnet.devops106_terraform_daniel_subnet_app_webserver2_tf.id
  route_table_id = aws_route_table.devops106_terraform_daniel_rt_public_tf.id
}

resource "aws_route_table_association" "devops106_terraform_daniel_rt_assoc_db_public_webserver_tf" {
  subnet_id      = aws_subnet.devops106_terraform_daniel_subnet_db_webserver_tf.id
  route_table_id = aws_route_table.devops106_terraform_daniel_rt_public_tf.id
}


resource "aws_network_acl" "devops106_terraform_daniel_nacl_app_public_tf" {
  vpc_id = local.vpc_id_var

  ingress {
    rule_no    = 100
    from_port  = 22
    to_port    = 22
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  ingress {
    rule_no    = 200
    from_port  = 27017
    to_port    = 27017
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  ingress {
    rule_no    = 300
    from_port  = 80
    to_port    = 80
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  ingress {
    rule_no    = 10000
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }


  egress {
    rule_no    = 100
    from_port  = 80
    to_port    = 80
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  egress {
    rule_no    = 200
    from_port  = 443
    to_port    = 443
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  egress {
    rule_no    = 10000
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  subnet_ids = [
    aws_subnet.devops106_terraform_daniel_subnet_app_webserver_tf.id,
    aws_subnet.devops106_terraform_daniel_subnet_app_webserver2_tf.id
  ]

  tags = {
    Name = "devops106_terraform_daniel_nacl_app_public"
  }
}

resource "aws_network_acl" "devops106_terraform_daniel_nacl_public_db_tf" {
  vpc_id = local.vpc_id_var

  ingress {
    rule_no    = 100
    from_port  = 22
    to_port    = 22
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  ingress {
    rule_no    = 200
    from_port  = 27017
    to_port    = 27017
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  ingress {
    rule_no    = 10000
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  egress {
    rule_no    = 100
    from_port  = 80
    to_port    = 80
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  egress {
    rule_no    = 200
    from_port  = 443
    to_port    = 443
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  egress {
    rule_no    = 10000
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }
  subnet_ids = [aws_subnet.devops106_terraform_daniel_subnet_db_webserver_tf.id]

  tags = {
    Name = "devops106_terraform_daniel_nacl_db_public"
  }
}


resource "aws_security_group" "devops106_terraform_daniel_sg_app_webserver_tf" {
  name   = "devops106_terraform_daniel_app_sg"
  vpc_id = local.vpc_id_var

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "devops106_terraform_daniel_sg_app_webserver"
  }
}

resource "aws_security_group" "devops106_terraform_daniel_sg_db_webserver_tf" {
  name   = "devops106_terraform_daniel_db_sg"
  vpc_id = local.vpc_id_var

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops106_terraform_daniel_sg_db_webserver"
  }
}


#data "template_file" "proxy_init" {
#  template = file("./init-scripts/nginx-install.sh")
#}
#
#resource "aws_instance" "devops106_terraform_daniel_proxy_server_tf" {
#  ami                    = var.ubuntu_20_04_ami_id_var
#  instance_type          = var.instance_type_var
#  key_name               = var.key_name_var
#  vpc_security_group_ids = [aws_security_group.devops106_terraform_daniel_sg_app_webserver_tf.id]
#
#  subnet_id                   = aws_subnet.devops106_terraform_daniel_subnet_app_webserver_tf.id
#  associate_public_ip_address = true
#
#
#  user_data = data.template_file.proxy_init.rendered
#
#  tags = {
#    Name = "devops106_terraform_daniel_proxy_server"
#  }
#
#  connection {
#    type        = "ssh"
#    user        = "ubuntu"
#    host        = self.public_ip
#    private_key = file(var.private_key_file_path_var)
#  }
#}


data "template_file" "app_init" {
  template = file("./init-scripts/docker-install.sh")
}

resource "aws_instance" "devops106_terraform_daniel_webserver_app_tf" {
  ami                    = var.ubuntu_20_04_docker_ami_id_var
  instance_type          = var.instance_type_var
  key_name               = var.key_name_var
  vpc_security_group_ids = [aws_security_group.devops106_terraform_daniel_sg_app_webserver_tf.id]

  subnet_id                   = aws_subnet.devops106_terraform_daniel_subnet_app_webserver_tf.id
  associate_public_ip_address = true

  # index starts at zero.
  count = 2

  user_data = data.template_file.app_init.rendered

  # use counter to give it uniques tag name
  tags = {
    Name = "devops106_terraform_daniel_app_webserver_${count.index}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file(var.private_key_file_path_var)
  }
}
resource "aws_instance" "devops106_terraform_daniel_webserver2_app_tf" {
  ami                    = var.ubuntu_20_04_ami_id_var
  instance_type          = var.instance_type_var
  key_name               = var.key_name_var
  vpc_security_group_ids = [aws_security_group.devops106_terraform_daniel_sg_app_webserver_tf.id]

  subnet_id                   = aws_subnet.devops106_terraform_daniel_subnet_app_webserver2_tf.id
  associate_public_ip_address = true

  # index starts at zero.
  count = 2

  user_data = data.template_file.app_init.rendered

  # use counter to give it uniques tag name
  tags = {
    Name = "devops106_terraform_daniel_app_webserver2_${count.index}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file(var.private_key_file_path_var)
  }
}


data "template_file" "db_init" {
  template = file("./init-scripts/mongodb-install.sh")
}

resource "aws_instance" "devops106_terraform_daniel_webserver_db_tf" {
  ami                    = var.ubuntu_20_04_ami_id_var
  instance_type          = var.instance_type_var
  key_name               = var.key_name_var
  vpc_security_group_ids = [aws_security_group.devops106_terraform_daniel_sg_db_webserver_tf.id]

  subnet_id                   = aws_subnet.devops106_terraform_daniel_subnet_db_webserver_tf.id
  associate_public_ip_address = true

  user_data = data.template_file.db_init.rendered

  tags = {
    Name = "devops106_terraform_daniel_db_webserver"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file(var.private_key_file_path_var)
  }
}


resource "aws_route53_zone" "devops106_terraform_daniel_dns_zone_tf" {
  name = "dungureanu.devops106"

  vpc {
    vpc_id = local.vpc_id_var
  }
}

resource "aws_route53_record" "devops106_terraform_daniel_dns_db_tf" {
  name    = "db"
  type    = "A"
  zone_id = aws_route53_zone.devops106_terraform_daniel_dns_zone_tf.zone_id
  ttl     = "30"
  records = [aws_instance.devops106_terraform_daniel_webserver_db_tf.public_ip]
}

resource "aws_lb" "devops106_terraform_daniel_lb_tf" {
  name               = "devops106-terraform-daniel-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [
    aws_subnet.devops106_terraform_daniel_subnet_app_webserver_tf.id,
    aws_subnet.devops106_terraform_daniel_subnet_app_webserver2_tf.id
  ]
  security_groups = [
    aws_security_group.devops106_terraform_daniel_sg_app_webserver_tf.id
  ]

  tags = {
    Name = "devops106_terraform_daniel_lb"
  }
}

resource "aws_alb_target_group" "devops106_terraform_daniel_tg_tf" {
  name        = "devops106-terraform-daniel-tg"
  port        = 5000
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = local.vpc_id_var
}

resource "aws_alb_target_group_attachment" "devops106_terraform_daniel_tg_attach_tf" {
  target_group_arn = aws_alb_target_group.devops106_terraform_daniel_tg_tf.arn
  count            = length(aws_instance.devops106_terraform_daniel_webserver_app_tf)
  target_id        = aws_instance.devops106_terraform_daniel_webserver_app_tf[count.index].id
}

resource "aws_alb_target_group_attachment" "devops106_terraform_daniel_tg_attach2_tf" {
  target_group_arn = aws_alb_target_group.devops106_terraform_daniel_tg_tf.arn
  count            = length(aws_instance.devops106_terraform_daniel_webserver2_app_tf)
  target_id        = aws_instance.devops106_terraform_daniel_webserver2_app_tf[count.index].id
}

resource "aws_lb_listener" "devops106_terraform_daniel_lb_listener_tf" {
  load_balancer_arn = aws_lb.devops106_terraform_daniel_lb_tf.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.devops106_terraform_daniel_tg_tf.arn
  }
}
