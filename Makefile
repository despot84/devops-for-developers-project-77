ping:
	ansible webservers -i ./ansible/inventory.ini -m ping

install-roles:
	ansible-galaxy install -r ./ansible/requirements.yml

remote-install:
	ansible-playbook -i ./ansible/inventory.ini ./ansible/playbook.yml

redmine-deploy:
	ansible-playbook --vault-password-file ./ansible/vault_password.txt -i ./ansible/inventory.ini -l webservers ./ansible/playbook.yml 

encrypt-vault:
	ansible-vault encrypt ./ansible/group_vars/webservers/vault.yml --vault-password-file ./ansible/vault_password.txt
