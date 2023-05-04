resource "null_resource" "consul_backup" {

   triggers = {
    timestamp = "${replace("${timestamp()}", "/[-| |T|Z|:]/", "")}"
  }

  provisioner "local-exec" {
    command = <<-EOT
        aws sts get-caller-identity
        aws eks update-kubeconfig --region eu-west-1 --name $CLUSTER_NAME
        SNAPSHOT=$(date +%y-%m-%d-%H-%m-%S | sed 's/\"//g')
        CONSUL_LEADER_NODE=$(kubectl -n consul exec consul-develop-consul-server-1 -- sh -c "export CONSUL_HTTP_TOKEN=$CONSUL_TOKEN && consul operator raft list-peers | grep leader | sed 's/ /\n/g' | grep consul | sed 's/\"//g'")
        kubectl -n consul exec $CONSUL_LEADER_NODE -- sh -c "export CONSUL_HTTP_TOKEN=$CONSUL_TOKEN && cd /consul/extra-config && consul snapshot save backup-$SNAPSHOT.snap"
        kubectl cp consul/$CONSUL_LEADER_NODE:/consul/extra-config/backup-$SNAPSHOT.snap ./backup-$SNAPSHOT.snap
        aws s3 cp ./backup-$SNAPSHOT.snap s3://consul-snapshots-storage/backup-$SNAPSHOT.snap
        rm backup-$SNAPSHOT.snap
    EOT

    environment = {
      CLUSTER_NAME = local.cluster_name
      CONSUL_TOKEN = data.kubernetes_secret.tool_token.data["token"]
    }
  }
}
