locals {
  nodepool_nets = [ for net in try(local.subnets.nodepools, []):
      {
        name = try(net.name, net.cidr)
        cidr = net.cidr
        public = try(net.public, false)
        acl = {}
      }
  ]
}
