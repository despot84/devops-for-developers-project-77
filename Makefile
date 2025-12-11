ping:
	ansible webservers -i ./ansible/inventory.ini -m ping


init:
	terraform init -backend-config=secret.backend.tfvars

i-upgrade:
	terraform init -upgrade -backend-config=secret.backend.tfvars

i-migrate:
	terraform init -migrate-state -backend-config=secret.backend.tfvars

plan:
	terraform plan

apply:
	terraform apply

destroy:
	terraform destroy

show:
	terraform show

graph:
	terraform graph
	
install-roles:
	ansible-galaxy install -r ./ansible/requirements.yml

remote-install:
	ansible-playbook -i ./ansible/inventory.ini ./ansible/playbook.yml

redmine-deploy:
	ansible-playbook --vault-password-file ./ansible/vault_password.txt -i ./ansible/inventory.ini -l webservers ./ansible/playbook.yml 

encrypt-vault:
	ansible-vault encrypt ./ansible/group_vars/webservers/vault.yml --vault-password-file ./ansible/vault_password.txt
