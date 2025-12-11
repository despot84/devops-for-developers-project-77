resource "local_file" "ansible_secrets" {
  content = templatefile("../ansible/group_vars/webservers/secrets.yml.template", {
    db_host     = yandex_mdb_postgresql_cluster.postgresql588.host[0].fqdn
    db_name     = var.db_name
    db_port     = "6432"
    db_user     = var.db_user
    db_password = var.db_password

    datadog_api_key = var.datadog_api_key
    datadog_site    = var.datadog_site
  })
  filename = "../ansible/group_vars/webservers/secrets.yml"
}