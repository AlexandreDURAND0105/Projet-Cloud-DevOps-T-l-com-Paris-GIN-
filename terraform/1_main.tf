#Configuration de notre provider
provider "aws" {
  region = "us-east-1"
  profile = "DevopsLab-708113109960"
}

#Lecture de notre VPC (déjà créé dans le cadre de notre projet)
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}