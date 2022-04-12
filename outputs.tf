# output "webserver_ip_addresses_output" {
#   value = aws_instance.devops106_terraform_daniel_webserver_app_tf[*].public_ip
# }

# output "webserver2_ip_addresses_output" {
#   value = aws_instance.devops106_terraform_daniel_webserver2_app_tf[*].public_ip
# }

output "mongoDB_server_ip_address" {
  value = aws_instance.devops106_terraform_daniel_db_server_tf.public_ip
}

#output "proxy_server_ip_address" {
#  value = aws_instance.devops106_terraform_daniel_proxy_server_tf.public_ip
#}
