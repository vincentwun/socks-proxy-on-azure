# Socks Proxy Server on Azure

This project uses Azure and Terraform to create an Ubuntu VM and provides a local SOCKS5 proxy via SSH Dynamic Port Forwarding (ssh -D).

The server only needs to have SSH enabled (openssh-server installed and allowed through the firewall).

## Requirements

- Azure CLI
- Terraform
- An Azure subscription (confirm region and cost)

## 1) Deploy — Create the VM

```bash
az login
terraform init
terraform plan
terraform apply
```

## 2) Client PC (Linux Ubuntu 24.04) — Create a local SOCKS5

### Obtain the private key and start SSH dynamic forwarding:

```bash
terraform output -raw ssh_private_key > proxy-ssh-key
chmod 600 proxy-ssh-key
ssh -i proxy-ssh-key azureuser@$(terraform output -raw public_ip_address) -fN -D 1080
```

Note: this command opens a local SOCKS5 port (127.0.0.1:1080) and forwards traffic through the SSH tunnel to the VM.

## 3) Browser configuration

- Firefox: Preferences → Proxy → Settings → Manual proxy configuration
  - SOCKS Host: 127.0.0.1
  - Port: 1080
  - Select SOCKS v5
  - Check "Proxy DNS when using SOCKS v5"

- Chrome:

```bash
google-chrome --proxy-server="socks5://127.0.0.1:1080"
```

## 4) Stop the proxy

```bash
pkill -f "ssh .* -D 1080"
```

## 5) Clean up — Destroy resources

```bash
terraform destroy
```