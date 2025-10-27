#Création de l'instance qui fera office de loadbalancer (sous-réseau public)

resource "aws_instance" "loadbalancer" {
  ami =                         var.instance_ami_loadbalancer
  instance_type =               var.instance_type_loadbalancer
  subnet_id =                   aws_subnet.public_sub.id
  vpc_security_group_ids =      [aws_security_group.security_group_all_egress.id,aws_security_group.security_group_loadbalancer.id]
  key_name =                    aws_key_pair.public_key_instances.key_name
  associate_public_ip_address = true
  source_dest_check =           true
  tags = {
    Name = var.instance_loadbalancer_name
  }
}