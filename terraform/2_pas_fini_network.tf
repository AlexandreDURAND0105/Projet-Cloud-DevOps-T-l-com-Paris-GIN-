### Création de nos sous-réseaux
resource "aws_subnet" "public_sub" {
  vpc_id     = data.aws_vpc.vpc.id
  cidr_block = var.public_cidr
  tags = {
    Name = var.public_sub_name
  }
}
resource "aws_subnet" "private_1_sub" {
  vpc_id     = data.aws_vpc.vpc.id
  cidr_block = var.private_1_cidr
  # Nécessaire par la suite pour la création d'interfaces, il faut que le sous-réseaux soient sur la même infrastructure.
  availability_zone = aws_subnet.public_sub.availability_zone
  tags = {
    Name = var.private_1_sub_name
  }
}
resource "aws_subnet" "private_2_sub" {
  vpc_id     = data.aws_vpc.vpc.id
  cidr_block = var.private_2_cidr
  availability_zone = aws_subnet.public_sub.availability_zone
  tags = {
    Name = var.private_2_sub_name
  }
}

### Création de la gateway
resource "aws_internet_gateway" "gateway" {
  vpc_id     = data.aws_vpc.vpc.id
  tags = {
    Name = var.gateway_name
  }
}

### Création des tables de routage pour chacun de nos sous-réseaux
resource "aws_route_table" "public_table" {
  vpc_id     = data.aws_vpc.vpc.id
  tags = {
    Name = var.public_table_name
  }
}
resource "aws_route_table" "private_1_table" {
  vpc_id     = data.aws_vpc.vpc.id
  tags = {
    Name = var.private_1_table_name
  }
}
resource "aws_route_table" "private_2_table" {
  vpc_id     = data.aws_vpc.vpc.id
  tags = {
    Name = var.private_2_table_name
  }
}


### Association des tables de routage avec les sous-réseaux respectifs
resource "aws_route_table_association" "association_public" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.public_table.id
}
resource "aws_route_table_association" "association_private_1" {
  subnet_id      = aws_subnet.private_1_sub.id
  route_table_id = aws_route_table.private_1_table.id
}
resource "aws_route_table_association" "association_private_2" {
  subnet_id      = aws_subnet.private_2_sub.id
  route_table_id = aws_route_table.private_2_table.id
}

### Création des routes par défaut pour chacun des sous-réseaux
resource "aws_route" "internet_access_public" {
  route_table_id         = aws_route_table.public_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}
resource "aws_route" "internet_access_private_1" {
  route_table_id         = aws_route_table.private_1_table.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.bastion_interface_private_1.id
}
resource "aws_route" "internet_access_private_2" {
  route_table_id         = aws_route_table.private_2_table.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.bastion_interface_private_2.id
}

# Récupération de la zone DNS publique déjà existante

data "aws_route53_zone" "dns_zone" {
  name         = var.zone_dns
  private_zone = false
}

# Création d'un enregistrement DNS de type A pour notre site internet

resource "aws_route53_record" "dns_entry" {
  zone_id = data.aws_route53_zone.dns_zone.zone_id
  name    = "${var.site_name}.${var.zone_dns}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.loadbalancer.public_ip]
}

