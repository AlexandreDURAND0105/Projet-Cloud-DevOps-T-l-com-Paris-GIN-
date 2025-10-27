### Génération du playbook Ansible pour les serveurs back-end
# Ce bloc crée un fichier `main.yaml` qui sera utilisé par Ansible pour :
# 1. Installer et configurer FFmpeg pour le streaming vidéo.
# 2. Créer un dossier vidéo et copier notre vidéo test.
# 4. Définir la liste des IPs des serveurs front-end et démarrer les flux vidéo vers eux.




resource "local_file" "server-back_config_file" {
  filename = "${path.module}/../ansible/roles/server-back/tasks/main.yaml"

  content = <<EOT

- name: Install ffmpeg
  apt:
    name: ffmpeg
    update_cache: yes

- name: Create video folder
  file:
    path: /videos
    state: directory

- name: Copy sample video
  copy:
    src: obrey.mp4
    dest: /videos/obrey.mp4
    mode: '0644'

- name: Define list of frontend IPs
  set_fact:
    frontend_ips:
        %{ for instance in aws_instance.machines_front ~}
        - ${instance.private_ip}
        %{ endfor ~}

- name: Start FFmpeg streams to all frontends
  shell: >
    nohup ffmpeg -stream_loop -1 -re -i /videos/obrey.mp4
    -c:v libx264 -c:a aac -f flv rtmp://{{ item }}:1935/live/miam
    > /dev/null 2>&1 &
  args:
    executable: /bin/bash
  loop: "{{ frontend_ips }}"
EOT
}

