### Hexlet tests and linter status:
[![Actions Status](https://github.com/despot84/devops-for-developers-project-77/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/despot84/devops-for-developers-project-77/actions)

### Requirements

* Terraform
* Ansible
* Make

### Подготовка
1. Terraform
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

2. Ansible 
```
sudo apt update
sudo apt install -y ansible python3-pip
pip3 install docker ansible-vault
make a-install-deps
```

3. Настройка
Добавить данные в файл ```terraform/secret.auto.tfvars```


### Как запустить приложение

**Клонируйте репозиторий**

```bash
git clone git@github.com:despot84/devops-for-developers-project-77/.git
```

Создать файл vault_password.txt
```
echo "ваш_пароль" > ./ansible/vault_password.txt
```

Создать файл ./ansible/group_vars/webservers/vault.yml
```
ansible-vault create ./ansible/group_vars/webservers/vault.yml --vault-password-file ./ansible/vault_password.txt
```
Вставить содержимое:
```
apps_localhost: localhost
vault_datadog_api_key: your_datadog_api_key

vault_some_db_postgres: you_postgress_host
vault_some_db_database: db
vault_some_db_username: postgres
vault_some_db_password: postgres
vault_some_db_port: 5432
```
Нажмите Esc, чтобы выйти из режима редактирования.
Введите :wq и нажмите Enter для сохранения и выхода.

**Выполнить**

```bash
make install-role

make redmine-deploy
```