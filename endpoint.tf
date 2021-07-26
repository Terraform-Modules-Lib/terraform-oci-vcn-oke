locals {
  endpoint_net = {
    name = try(local.subnets.endpoint.name, "endpoint")
    cidr = local.subnets.endpoint.cidr
    public = try(local.subnets.endpoint.public, false)
    acl = local.acl_workers_to_endpoint
  }
  
  
  acl_workers_to_endpoint = { for net in try(local.subnets.nodepools, []):
    format("%s_to_endpoint", try(net.name, net.cidr)) => {
      description = "Kubernetes worker to Kubernetes API endpoint communication."
      source = net.cidr
      protocol = "tcp"
      dst_port = 6443
    }
  }
    
    
}
