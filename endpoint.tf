locals {
  endpoint_net = {
    name = try(local.subnets.endpoint.name, "endpoint")
    cidr = local.subnets.endpoint.cidr
    public = try(local.subnets.endpoint.public, false)
    acl = {
      ingress = {
        workers_to_endpoint = { for net in try(local.subnets.nodepools, []):
          format("%s_to_endpoint", try(net.name, net.cidr)) => {
            description = "Kubernetes worker to Kubernetes API endpoint communication."
            source = net.cidr
            protocol = "tcp"
            dst_port = 6443
          }
        }

        workers_to_controlplane = { for net in try(local.subnets.nodepools, []):
          format("%s_to_controlplane", try(net.name, net.cidr)) => {
            description = "Kubernetes worker to control plane communication."
            source = net.cidr
            protocol = "tcp"
            dst_port = 12250
          }
        }
    
        path_discovery = { for net in try(local.subnets.nodepools, []):
          format("%s_path_discovery", try(net.name, net.cidr)) => {
            description = "Path discovery."
            source = net.cidr
            protocol = "icmp"
            type = 3
            code = 4
          }
        }
      }
    }
  }
}
