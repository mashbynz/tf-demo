init:
	$(CMD) terraform init -backend-config="dev/backend.tfvars"

apply:
	$(CMD) terraform apply

plan:
	$(CMD) terraform plan

remove:
	$(CMD) terraform destroy