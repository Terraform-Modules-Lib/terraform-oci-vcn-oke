locals {
  ingress_net = {
    name = try(local.subnets.ingress.name, "ingress")
    cidr = local.subnets.ingress.cidr
    public = try(local.subnets.ingress.public, true)
    acl = {}
  }
}
