### Génération du fichier de configuration Nginx pour le load balancer
# Ce bloc crée un fichier `loadbalancer.conf` utilisé par Ansible pour configurer Nginx.
# Il définit le routage du trafic HTTP/HTTPS vers les instances front-end et permet d'avoir un certificat via letsencrpyt.

resource "local_file" "loadbalancer_config_file" {
  filename = "${path.module}/../ansible/roles/loadbalancer/tasks/loadbalancer.conf"

  content = <<EOT
upstream front_servers {
    %{ for instance in aws_instance.machines_front ~}
    server ${instance.private_ip}:80;
    %{ endfor ~}
}

server {
    listen 80;
    server_name ${var.site_name}.${var.zone_dns};

    # Redirection HTTP vers HTTPS
    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 443 ssl;
    server_name ${var.site_name}.${var.zone_dns};
    ssl_certificate /etc/letsencrypt/live/${var.site_name}.${var.zone_dns}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${var.site_name}.${var.zone_dns}/privkey.pem;

    location / {
        proxy_pass http://front_servers;

        proxy_http_version 1.1;
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header Connection        "";
    }
}

EOT
}



resource "local_file" "loadbalancer_config_file_bis" {
  filename = "${path.module}/../ansible/roles/loadbalancer/vars/main.yaml"

  content = <<EOT

domain: "${var.site_name}.${var.zone_dns}"
email: "devops@intuitivesoft.cloud"

EOT
}