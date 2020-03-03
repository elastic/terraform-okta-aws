export TF_IN_AUTOMATION=true

.terraform:
	terraform init

plan: .terraform
	terraform plan

apply: .terraform
	terraform apply -auto-approve

output: .terraform
	terraform refresh
	terraform output -json > output_example.json

destroy: .terraform
	terraform destroy -auto-approve

fmt:
	terraform fmt .

clean:
	rm -rf .terraform

.PHONY: plan apply output destroy clean fmt
