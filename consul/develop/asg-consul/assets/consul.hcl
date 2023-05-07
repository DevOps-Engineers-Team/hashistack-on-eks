datacenter = "${datacenter_name}"

server = false

data_dir = "/home/ec2-user"
retry_join = ["${retry_join_url}"]
encrypt = "${encryption_keyring}"

acl = {
  enabled = true
  default_policy = "deny"
  enable_token_persistence = true
  tokens {
    agent = "${consul_acl_token}"
  }
}

verify_incoming = true
verify_outgoing = true
verify_server_hostname = true

ca_file = "/home/ec2-user/consul-agent-ca.pem"

auto_encrypt = {
  tls = true
}
