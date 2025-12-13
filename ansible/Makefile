ping:
	ansible webservers -i inventory.ini -m ping

install-roles:
	ansible-galaxy install -r requirements.yml

remote-install:
	ansible-playbook -i inventory.ini playbook.yml

redmine-deploy:
	ansible-playbook --vault-password-file vault_password.txt -i inventory.ini -l webservers playbook.yml 

encrypt-vault:
	ansible-vault encrypt group_vars/webservers/vault.yml --vault-password-file vault_password.txt
