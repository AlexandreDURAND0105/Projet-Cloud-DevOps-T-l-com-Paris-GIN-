### Création d'un fichier local pour l'inventaire Ansible
# Ce bloc génère automatiquement un fichier `inventory.ini` qui contient
# toutes les instances manipulées par Ansible, avec leurs IPs et paramètres de connexion

resource "local_file" "inventory" {
  filename = "${path.module}/../ansible/inventory.ini"

  content = <<EOT
[bastion]
${aws_instance.bastion.tags["Name"]} ansible_host=${aws_eip.bastion_ip.public_ip}

[bastion:vars]
ansible_ssh_private_key_file=${local_file.private_key_bastion.filename}
ansible_user=ubuntu

[loadbalancer]
${aws_instance.loadbalancer.tags["Name"]} ansible_host=${aws_instance.loadbalancer.private_ip}
[loadbalancer:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=${local_file.private_key_instances.filename}
ansible_ssh_common_args='-o ProxyCommand="ssh -i ${local_file.private_key_bastion.filename} -W %h:%p ubuntu@${aws_eip.bastion_ip.public_ip}"'

[server-front]
%{ for instance in aws_instance.machines_front ~}
${instance.tags["Name"]} ansible_host=${instance.private_ip}
%{ endfor ~}

[server-front:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=${local_file.private_key_instances.filename}
ansible_ssh_common_args='-o ProxyCommand="ssh -i ${local_file.private_key_bastion.filename} -W %h:%p ubuntu@${aws_eip.bastion_ip.public_ip}"'

[server-back]
%{ for instance in aws_instance.machines_back ~}
${instance.tags["Name"]} ansible_host=${instance.private_ip}
%{ endfor ~}

[server-back:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=${local_file.private_key_instances.filename}
ansible_ssh_common_args='-o ProxyCommand="ssh -i ${local_file.private_key_bastion.filename} -W %h:%p ubuntu@${aws_eip.bastion_ip.public_ip}"'

EOT
}

