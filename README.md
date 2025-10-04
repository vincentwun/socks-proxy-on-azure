# Socks Proxy Server on Azure

## Overview

This project automates the provisioning of a lightweight SOCKS5 proxy server on Microsoft Azure using Terraform. It creates an Ubuntu virtual machine configured for SSH Dynamic Port Forwarding, enabling secure internet traffic routing via a local SOCKS proxy.


## Prerequisites

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?view=azure-cli-latest&pivots=apt) installed and logged in (`az login`).  
- [Terraform CLI](https://developer.hashicorp.com/terraform/install)
- An active Azure subscription.

## Quick Start

```bash
git clone https://github.com/vincentwun/socks-proxy-on-azure.git
cd socks-proxy-on-azure

# Install required tools
./install.sh
```

## Deployment

```bash
# Initialize Terraform
terraform init

# Review changes
terraform plan

# Provision infrastructure
terraform apply --auto-approve
```

## Connect and Use Proxy

1. **Retrieve SSH key**  
   ```bash
   terraform output -raw ssh_private_key > proxy_key.pem
   chmod 600 proxy_key.pem
   ```

2. **Start SOCKS5 tunnel**  
   ```bash
   ssh -i proxy_key.pem -fN -D 1080 ${TF_VAR_admin_username}@$(terraform output -raw public_ip_address)
   ```

3. **Verify**  
   Ensure local port 1080 is listening:  
   ```bash
   ss -ln | grep 1080
   ```

## Browser Configuration

- **Firefox**  
  Preferences → Network Settings → Manual proxy configuration  
  - SOCKS Host: `127.0.0.1`  
  - Port: `1080`  
  - SOCKS v5 & Proxy DNS

- **Chrome**  
  ```bash
  google-chrome --proxy-server="socks5://127.0.0.1:1080"
  ```

## Stopping and Cleanup

- Stop the SSH tunnel:  
  ```bash
  pkill -f "ssh .* -D 1080"
  ```

- Destroy Azure resources:  
  ```bash
  terraform destroy --auto-approve
  ```