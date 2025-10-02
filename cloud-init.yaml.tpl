#cloud-config
package_update: true
package_upgrade: false

packages:
  - ufw
  - openssh-server

write_files:
  - path: /etc/cloud/cloud.cfg.d/99_disable_root.cfg
    content: |
      disable_root: true
    owner: root:root
    permissions: '0644'

  - path: /etc/ssh/sshd_config.d/50-cloud-init.conf
    content: |
      PermitRootLogin no
      PasswordAuthentication no
    owner: root:root
    permissions: '0644'

runcmd:
  - [ sh, -c, 'ufw allow OpenSSH' ]
  - [ sh, -c, 'echo "y" | ufw enable' ]
  - [ sh, -c, 'systemctl restart sshd || true' ]
