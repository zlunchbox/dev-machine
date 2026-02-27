# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

Provisions and configures a throwaway EC2 development VM using Terraform and Ansible. The intended workflow is `terraform apply` → Ansible provision → work → `terraform destroy`. No state is stored on the VM; all work must be committed to git.

## Repository Structure

- `setup.sh` — interactive CLI to generate `terraform/terraform.tfvars` and `ansible/vars.yml`
- `terraform/` — provisions a `t3.medium` Ubuntu 24.04 LTS EC2 instance
- `ansible/` — configures the instance (git, deno, tmux, build-essential)

## Workflow

```bash
# 1. First-time config (generates terraform.tfvars and ansible/vars.yml)
./setup.sh

# 2. Provision infrastructure
cd terraform
terraform init        # first time only
terraform apply

# 3. Configure the instance
ansible-playbook -i "$(terraform output -raw instance_public_ip)," ../ansible/playbook.yml

# 4. Connect (SSH command printed as terraform output)
ssh -A -i ~/.ssh/dev-machine-key ubuntu@<ip>

# 5. Tear down
terraform destroy
```

## Terraform

- **State**: local only
- **Networking**: default VPC; security group restricts SSH (port 22) to `my_ip` only
- **AMI**: always resolves to latest Ubuntu 24.04 LTS from Canonical (`099720109477`)
- **EBS**: `delete_on_termination = true` — volume is destroyed with the instance
- Requires Terraform ≤ 1.8.x on macOS 11 (newer binaries require macOS 12+); use `tfenv`
- `terraform.tfvars` is gitignored; `terraform.tfvars.example` is the committed template

## Ansible

- `ansible/ansible.cfg` sets `remote_user = ubuntu`, disables host key checking (necessary for ephemeral VMs with rotating IPs), and enables SSH agent forwarding
- Roles: `common` (apt upgrade, git, tmux, build-essential, curl, unzip, optional git config) and `deno` (system-wide install to `/usr/local/bin`)
- `ansible/vars.yml` is gitignored; `ansible/vars.yml.example` is the committed template
- `git_user_name` and `git_user_email` in `vars.yml` are optional — git config is only applied when set

## Python / Package Manager

Uses `uv` with Python 3.13. Ansible is the only dependency.

```bash
uv sync                  # install dependencies
uv run ansible-playbook  # run ansible commands
```
