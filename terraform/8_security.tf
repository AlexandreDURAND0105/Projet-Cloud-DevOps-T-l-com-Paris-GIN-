### Groupe de sécurité du bastion interface public
resource "aws_security_group" "security_group_bastion_public" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = var.security_group_name_bastion
  }
}
# On autorise la connexion ssh depuis n'importe quelle ip (on aurait pu être un peu plus précis pour la plage d'ip)
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.security_group_bastion_public.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol    = "tcp"
}



### Groupe de sécurité bastion interface private 1
resource "aws_security_group" "security_group_bastion_private_1" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = var.security_group_name_bastion
  }
}
# On autorise n'importe quel trafic pour vu qu'il provienne du sous-réseau privé 1 (on aurait pu préciser quels protocoles exactement)
resource "aws_vpc_security_group_ingress_rule" "allow_from_private_1" {
  security_group_id = aws_security_group.security_group_bastion_private_1.id
  cidr_ipv4 = "10.0.128.0/18"
  ip_protocol    = -1
}



### Groupe de sécurité bastion interface private 2
resource "aws_security_group" "security_group_bastion_private_2" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = var.security_group_name_bastion
  }
}
# On autorise n'importe quel trafic pour vu qu'il provienne du sous-réseau privé 2 (on aurait pu préciser quels protocoles exactement)
resource "aws_vpc_security_group_ingress_rule" "allow_from_private_2" {
  security_group_id = aws_security_group.security_group_bastion_private_2.id
  cidr_ipv4 = "10.0.192.0/18"
  ip_protocol    = -1
}




### Groupe de sécurité pour toutes les instances qui autorisent toutes les communications sortantes (ici aussi on aurait pu traiter au cas par cas)
resource "aws_security_group" "security_group_all_egress" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = var.security_group_name_all_egress
  }
}
resource "aws_vpc_security_group_egress_rule" "allow_all_out" {
  security_group_id = aws_security_group.security_group_all_egress.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}




### Groupe de sécurité instances back-end
resource "aws_security_group" "security_group_back" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = var.security_group_name_ssh_from_bastion
  }
}
# La seule connexion entrante autorisée et la connexion ssh initiée par le bastion
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_bastion_back" {
  security_group_id = aws_security_group.security_group_back.id
  cidr_ipv4 = "${aws_network_interface.bastion_interface_private_2.private_ip}/32"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}


### Groupe de sécurité instances front-end
resource "aws_security_group" "security_group_front" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = var.security_group_name_front
  }
}
# On autorise la connexion entrante ssh initiée par le bastion
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_bastion_front" {
  security_group_id = aws_security_group.security_group_front.id
  cidr_ipv4 = "${aws_network_interface.bastion_interface_private_1.private_ip}/32"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}
# On autorise la connexion http entrante initiée par le loadbalancer (pas besoin de crypter la communication entre loadbalancer et front-end)
resource "aws_vpc_security_group_ingress_rule" "allow_http_from_loadbalancer" {
  security_group_id = aws_security_group.security_group_front.id
  cidr_ipv4 = "${aws_instance.loadbalancer.private_ip}/32"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}
# On autorise la connexion tcp entrante (sur le port d'écoute de notre serveur rtmp)  initiée par les instances back-end
resource "aws_vpc_security_group_ingress_rule" "allow_rtmp_from_backend" {
  security_group_id = aws_security_group.security_group_front.id
  cidr_ipv4 = aws_subnet.private_2_sub.cidr_block
  from_port = 1935
  to_port = 1935
  ip_protocol = "tcp"
}




### Groupe de sécurité instance loadbalancer
resource "aws_security_group" "security_group_loadbalancer" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = var.security_group_name_loadbalancer
  }
}
# On autorise la connexion entrante ssh initiée par le bastion
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_bastion_load" {
  security_group_id = aws_security_group.security_group_loadbalancer.id
  cidr_ipv4 = "${aws_network_interface.bastion_interface_public.private_ip}/32"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}
# On autorise la connexion http entrante depuis n'importe quelle ip (depuis l'extérieur)
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.security_group_loadbalancer.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  ip_protocol = "tcp"
  to_port = 80
}
# On autorise la connexion https entrante depuis n'importe quelle ip (depuis l'extérieur)
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.security_group_loadbalancer.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  ip_protocol = "tcp"
  to_port = 443
}


