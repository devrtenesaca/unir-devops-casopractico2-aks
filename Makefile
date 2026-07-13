
PREFIX ?= unir-caso2
TF_DIR ?= infra
ANSIBLE_DIR := ansible
INVENTORY := inventory.ini
TAG=casopractico2
SSH_KEY_DIR = ~/.ssh
SSH_KEY_NAME = id_rsa
SSH_PUB_KEY = $(SSH_KEY_DIR)/$(SSH_KEY_NAME).pub
SSH_PRIV_KEY = $(SSH_KEY_DIR)/$(SSH_KEY_NAME)


.PHONY: infra_init infra_fmt infra_validate infra_apply infra_destroy ansible_inventory build_push_image  deploy_caso2 destroy_caso2 


infra_init:
	@echo "Initializing Terraform..."
	cd infra/$* &&\
	terraform  init -input=false
infra_fmt:
	@echo "Formatting Terraform files..."
	cd infra/$* &&\
	terraform fmt -recursive
infra_validate:
	@echo "Validating Terraform files..."
	cd infra/$* &&\
	terraform validate

infra_apply:
	@echo "Applying Terraform files..."
	cd infra/$* &&\
	terraform apply -auto-approve

infra_destroy:
	@echo "Destroying Terraform files..."
	cd infra/$* &&\
	terraform destroy -auto-approve

#------------------------------------------
#build and push docker image to ACR
#------------------------------------------
ansible_build_push_aks:
	@echo "Building and pushing Docker image to ACR..."
	cd $(ANSIBLE_DIR) && \
	ansible-playbook  playbook_build_push.yaml 	
	
#------------------------------------------
#deploy with ansible
#------------------------------------------
ansible_deploy_aks:
	@echo "Deploying with Ansible..."
	cd $(ANSIBLE_DIR) &&\
	ansible-playbook  playbook_deploy_aks.yaml


deploy_caso2_aks:
	@echo "Deploying Caso 2..."
	$(MAKE) infra_init
	$(MAKE) infra_fmt
	$(MAKE) infra_validate
	$(MAKE) infra_apply
	$(MAKE) ansible_build_push_aks
	$(MAKE) playbook_deploy_aks





destroy_caso2_aks:
	@echo "Destroying infra Caso 2..."
	$(MAKE) infra_destroy