ping:
	ansible webservers -i ./ansible/inventory.ini -m ping


t-init:
	./terraform/terraform init -backend-config=./terraform/secret.backend.tfvars

t-upgrade:
	./terraform/terraform init -upgrade -backend-config=./terraform/secret.backend.tfvars

t-migrate:
	./terraform/terraform init -migrate-state -backend-config=./terraform/secret.backend.tfvars

t-plan:
	./terraform/terraform plan

t-apply:
	./terraform/terraform apply

t-destroy:
	./terraform/terraform destroy

t-show:
	./terraform/terraform show

t-graph:
	./terraform/terraform graph

a-install-roles:
	ansible-galaxy install -r ./ansible/requirements.yml

a-remote-install:
	ansible-playbook -i ./ansible/inventory.ini ./ansible/playbook.yml

a-redmine-deploy:
	ansible-playbook --vault-password-file ./ansible/vault_password.txt -i ./ansible/inventory.ini -l webservers ./ansible/playbook.yml 

a-encrypt-vault:
	ansible-vault encrypt ./ansible/group_vars/webservers/vault.yml --vault-password-file ./ansible/vault_password.txt
