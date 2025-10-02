# Socks Proxy Server On Azure

# Requirements

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?view=azure-cli-latest&pivots=apt)

- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

- [Azure Free Account](https://azure.microsoft.com/en-us/pricing/purchase-options/azure-account?icid=azurefreeaccount#freeservices)


# Build a VM Server

## Login

```bash
az login
terraform init
terraform plan
terraform apply
```



# Client PC Setting (Linux Ubuntu24):

1. Install Proxychains4

```bash
sudo apt update && sudo apt install proxychains4 -y
```

```bash
printf 'socks5 127.0.0.1 1080\n' | sudo tee -a /etc/proxychains4.conf > /dev/null
```

```bash
terraform output -raw ssh_private_key > proxy-ssh-key
chmod 600 proxy-ssh-key
ssh -i proxy-ssh-key azureuser@$(terraform output -raw public_ip_address) -fN -D 1080
```

# Broswer Setting

## Firefox Setting：

Preferences -> Proxy -> Settings -> Manual proxy configuration

- SOCKS Host: 127.0.0.1
- Port: 1080
- Checked: "SOCKS v5", "Proxy DNS when using SOCKS v5"
- Checked: "Proxy DNS when using SOCKS v5"

## Chrome:

google-chrome --proxy-server="socks5://127.0.0.1:1080"

# Stop Proxy

```bash
pkill -f "ssh .* -D 1080"
```

# Clean up

```bash
terraform destroy
```