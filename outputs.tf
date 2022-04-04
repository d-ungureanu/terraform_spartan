output "webserver_ip_addresses_output" {
  value = aws_instance.devops106_dungureanu_terraform_webserver_app_tf.public_ip
}