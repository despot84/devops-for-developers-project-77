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
Пример файла находится ```terraform/secret.auto.tfvars.template```

### Как запустить приложение

**Клонируйте репозиторий**

```bash
git clone https://github.com/despot84/devops-for-developers-project-77.git
```

Создать файл vault_password.txt
```
echo "ваш_пароль" > ./ansible/vault_password.txt
```
**Инфраструктура(terraform)**
```
make t-init

make t-apply
```

**Развертывание (Ansible)**
```bash
make a-install-role

make a-redmine-deploy
```