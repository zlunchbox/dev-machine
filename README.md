# dev-machine

Provisions and configures a throwaway EC2 development VM using Terraform and Ansible. Spin it up, do your work, tear it down. No state lives on the VM — commit everything to git.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) (≤ 1.8.x on macOS 11; use [tfenv](https://github.com/tfutils/tfenv))
- [uv](https://docs.astral.sh/uv/getting-started/installation/) (manages Python and Ansible)
- [AWS CLI](https://aws.amazon.com/cli/) configured with an SSO profile
- An SSH key pair at `~/.ssh/dev-machine-key` / `~/.ssh/dev-machine-key.pub`

## Usage

**1. Configure**

```bash
bin/setup
```

Generates `terraform/terraform.tfvars` and `ansible/vars.yml` from your input. Re-run at any time to update settings (e.g. if your IP changes).

**2. Install dependencies** (first time only)

```bash
uv sync
cd terraform && terraform init
```

**3. Provision**

```bash
bin/provision
```

Runs `terraform apply` to create the EC2 instance, then runs Ansible to configure it. Prints the SSH command when done.

**4. Connect**

```bash
ssh -A -i ~/.ssh/dev-machine-key ubuntu@<ip>
```

SSH agent forwarding is enabled so your local keys work on the remote.

**5. Tear down**

```bash
bin/deprovision
```

Runs `terraform destroy`. The EBS volume is deleted with the instance.

## What gets installed

| Tool | Details |
|---|---|
| git | With optional global `user.name` / `user.email` |
| tmux | Terminal multiplexer |
| build-essential | GCC, make, etc. |
| curl / unzip | General utilities |
| deno | Installed system-wide to `/usr/local/bin` |

## Configuration

Both config files are gitignored. Use the `.example` files as reference.

**`terraform/terraform.tfvars`**

| Variable | Default | Description |
|---|---|---|
| `aws_region` | `us-east-2` | AWS region to deploy into |
| `instance_type` | `t3.medium` | EC2 instance type |
| `root_volume_size` | `20` | EBS volume size in GB |
| `public_key_path` | `~/.ssh/dev-machine-key.pub` | SSH public key to register with AWS |
| `my_ip` | — | Your public IP in CIDR notation (e.g. `1.2.3.4/32`) |

**`ansible/vars.yml`**

| Variable | Description |
|---|---|
| `git_user_name` | Global git `user.name` (optional) |
| `git_user_email` | Global git `user.email` (optional) |

## Credits

Imagined by Zachary Luettgen
Built by Claude Sonnet 4.6
