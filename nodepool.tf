locals {
  nodepool_nets = [ for net in try(local.subnets.nodepools, []):
    {
      name = try(net.name, net.cidr)
      cidr = net.cidr
      public = try(net.public, false)
      acl = {
        ingress = merge(
          { for net in try(local.subnets.nodepools, []):
              format("%s_to_%s", try(net.name, net.cidr)) => {
                description = "Allow pods on one worker node to communicate with pods on other worker nodes."
                source = net.cidr
              }
          },
          { workers_to_controlplane = {
              description = "Allow Kubernetes control plane to communicate with worker nodes."
              source = local.cidrs.endpoint
              protocol = "tcp"
            }
          },
          { path_discovery = {
              description = "Path discovery."
              source = "0.0.0.0/0"
              protocol = "icmp"
              type = 3
              code = 4
            }
          },
          { worker_ssh = {
              description = "(optional) Allow inbound SSH traffic to worker nodes."
              source = local.cidrs.endpoint
              protocol = "tcp"
              dst_port = 22
            }
          }

        )
      }
    }
  ]
}
