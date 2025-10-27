#Création du nombre d'instance front-end que l'on souhaite (serveurs de streaming)
resource "aws_instance" "machines_front" {
  count                       = var.nombre_instance_front
  ami                         = var.instance_ami_front
  instance_type               = var.instance_type_front
  subnet_id                   = aws_subnet.private_1_sub.id
  vpc_security_group_ids      = [aws_security_group.security_group_all_egress.id,aws_security_group.security_group_front.id]
  key_name                    = aws_key_pair.public_key_instances.key_name
  associate_public_ip_address = false
  source_dest_check           = true
  tags = {
    Name = "${var.instance_front_name}-${count.index}"
  }
}