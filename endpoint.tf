locals {
  endpoint_net = {
    name = try(local.subnets.endpoint.name, "endpoint")
    cidr = local.subnets.endpoint.cidr
    public = try(local.subnets.endpoint.public, false)
    acl = {
      ingress = merge(
        { for net in try(local.subnets.nodepools, []):
            format("%s_to_endpoint", try(net.name, net.cidr)) => {
              description = "Kubernetes worker to Kubernetes API endpoint communication."
              source = net.cidr
              protocol = "tcp"
              dst_port = 6443
            }
        },
        { for net in try(local.subnets.nodepools, []):
            format("%s_to_controlplane", try(net.name, net.cidr)) => {
              description = "Kubernetes worker to control plane communication."
              source = net.cidr
              protocol = "tcp"
              dst_port = 12250
            }
        },
        { for net in try(local.subnets.nodepools, []):
            format("%s_path_discovery", try(net.name, net.cidr)) => {
              description = "Path discovery."
              source = net.cidr
              protocol = "icmp"
              type = 3
              code = 4
            }
        }
      )

      egress = merge(
        { oci_services = {
            description = "Allow Kubernetes control plane to communicate with OKE."
            destination = "0.0.0.0/0"
            protocol = "tcp"
            dst_port = 443
          }
        },
        { for net in try(local.subnets.nodepools, []):
            format("endpoint_to_%s", try(net.name, net.cidr)) => {
              description = "All traffic to worker nodes."
              destination = net.cidr
              protocol = "tcp"
            }
        },
        { for net in try(local.subnets.nodepools, []):
            format("path_discovery_%s", try(net.name, net.cidr)) => {
              description = "Path discovery."
              destination = net.cidr
              protocol = "icmp"
              type = 3
              code = 4
            }
        }
      )

    }
  }
  
  
}
