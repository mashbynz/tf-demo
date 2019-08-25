init:
	$(CMD) terraform init -backend-config="dev/backend.tfvars"

apply:
	$(CMD) terraform apply

remove:
	$(CMD) terraform destroy