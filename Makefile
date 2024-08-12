.PHONY: all create start stop delete provision info ssh

VM_NAME=ubuntu-server
OS_VERSION=jammy
CPU=2
MEMORY=2G
DISK=10G
ANSIBLE_PLAYBOOK=provisioning/playbook.yaml
CLOUD_CONFIG=provisioning/cloud-init/cloud-config.yaml
INVENTORY_FILE=inventory/hosts.ini

all: create provision

create:
	@if [ -z "$(network)" ]; then \
		echo "Error: network is not set. Use 'make create network=<network_interface>'"; \
		exit 1; \
	fi
	@echo "Creating the VM..."
	@multipass launch $(OS_VERSION) --name $(VM_NAME) --cpus $(CPU) --memory $(MEMORY) --disk $(DISK) --cloud-init $(CLOUD_CONFIG) --network=$(network)
	@echo "VM created successfully. Please update $(INVENTORY_FILE) manually if needed."

provision:
	@echo "Provisioning the VM with Ansible..."
	@ansible-playbook -i $(INVENTORY_FILE) $(ANSIBLE_PLAYBOOK) --limit multipass

start:
	@echo "Starting the VM..."
	@multipass start $(VM_NAME)

stop:
	@echo "Stopping the VM..."
	@multipass stop $(VM_NAME)

delete:
	@echo "Deleting the VM..."
	@multipass delete $(VM_NAME)
	@multipass purge
	@echo "VM deleted and resources purged."

info:
	@echo "Getting information about the VM..."
	@multipass info $(VM_NAME)

ssh:
	@echo "Connecting to the VM via SSH..."
	@multipass ssh $(VM_NAME)

refresh:
	@echo "Refreshing the VM..."
	@make stop
	@make start
	@make provision
