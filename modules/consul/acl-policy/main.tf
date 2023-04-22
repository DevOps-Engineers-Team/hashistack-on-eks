resource "consul_acl_policy" "test" {
  name        = "my_policy"
  datacenters = ["dc1"]
  rules       = <<-RULE
    node_prefix "" {
      policy = "read"
    }
    RULE
}