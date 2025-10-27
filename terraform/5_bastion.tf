# Création addresse public pour l'interface publique de notre instance bastion
resource "aws_eip" "bastion_ip" {
  domain = "vpc"
}

### Création des différents interfaces de notre instance bastion sur chacun des sous-réseaux
resource "aws_network_interface" "bastion_interface_public" {
  subnet_id       = aws_subnet.public_sub.id
  security_groups = [aws_security_group.security_group_all_egress.id,aws_security_group.security_group_bastion_public.id]
  source_dest_check  =  true
}
resource "aws_eip_association" "bastion_ip_association" {
  allocation_id        = aws_eip.bastion_ip.id
  network_interface_id = aws_network_interface.bastion_interface_public.id
}

resource "aws_network_interface" "bastion_interface_private_1" {
  subnet_id       = aws_subnet.private_1_sub.id
  security_groups = [aws_security_group.security_group_all_egress.id,aws_security_group.security_group_bastion_private_1.id]
  source_dest_check  = false
}
resource "aws_network_interface" "bastion_interface_private_2" {
  subnet_id       = aws_subnet.private_2_sub.id
  security_groups = [aws_security_group.security_group_all_egress.id,aws_security_group.security_group_bastion_private_2.id]
  source_dest_check  = false
}

#Création de l'instance qui fera office de bastion (sous-réseau public)

resource "aws_instance" "bastion" {
  ami                         = var.instance_ami_bastion
  instance_type               = var.instance_type_bastion
  key_name                    = aws_key_pair.public_key_bastion.key_name
  tags = {
    Name = var.instance_bastion_name
  }
  network_interface {
    network_interface_id = aws_network_interface.bastion_interface_public.id
    device_index         = 0
  }
  network_interface {
    network_interface_id = aws_network_interface.bastion_interface_private_1.id
    device_index         = 1
  }
  network_interface {
    network_interface_id = aws_network_interface.bastion_interface_private_2.id
    device_index         = 2
  }
}