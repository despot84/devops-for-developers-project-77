ping:
	ansible webservers -i ./ansible/inventory.ini -m ping


init:
	terraform/terraform init -backend-config=sterraform/ecret.backend.tfvars

i-upgrade:
	terraform/terraform init -upgrade -backend-config=terraform/secret.backend.tfvars

i-migrate:
	terraform/terraform init -migrate-state -backend-config=terraform/secret.backend.tfvars

plan:
	terraform/terraform plan

apply:
	terraform/terraform apply

destroy:
	terraform/terraform destroy

show:
	terraform/terraform show

graph:
	terraform/terraform graph

install-roles:
	ansible-galaxy install -r ./ansible/requirements.yml

remote-install:
	ansible-playbook -i ./ansible/inventory.ini ./ansible/playbook.yml

redmine-deploy:
	ansible-playbook --vault-password-file ./ansible/vault_password.txt -i ./ansible/inventory.ini -l webservers ./ansible/playbook.yml 

encrypt-vault:
	ansible-vault encrypt ./ansible/group_vars/webservers/vault.yml --vault-password-file ./ansible/vault_password.txt
