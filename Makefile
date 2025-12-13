ping:
	make -C ansible ping

t-init:
	make -C terraform init

t-upgrade:
	make -C terraform upgrade

t-migrate:
	make -C terraform migrate

t-plan:
	make -C terraform plan

t-apply:
	make -C terraform apply

t-destroy:
	make -C terraform destroy

t-show:
	make -C terraform show

t-graph:
	make -C terraform graph

a-install-roles:
	make -C ansible install-roles

a-remote-install:
	make -C ansible remote-install

a-redmine-deploy:
	make -C ansible redmine-deploy

a-encrypt-vault:
	make -C ansible encrypt-vault
