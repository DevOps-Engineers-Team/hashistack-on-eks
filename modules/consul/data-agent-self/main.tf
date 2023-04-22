data "consul_agent_self" "agent_config" {
#   query_options {
#     datacenter = var.datacenter_name
#   }
}

data "consul_nodes" "nodes" {
#   query_options {
#     # Optional parameter: implicitly uses the current datacenter of the agent
#     datacenter = "dc1"
#   }
}