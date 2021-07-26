locals {
  endpoint_net = {
    name = try(local.subnets.endpoint.name, "endpoint")
    cidr = local.subnets.endpoint.cidr
    public = try(local.subnets.endpoint.public, false)
    acl = {}
  }
}
