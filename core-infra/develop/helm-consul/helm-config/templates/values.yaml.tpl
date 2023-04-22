global:
    datacenter: ${datacenter_name}
    image: ${image_version}
    acls:
        manageSystemACLs: ${manage_system_acl}
    gossipEncryption:
        autoGenerate: false
        secretName: consul-gossip-encrypt-keyring
        secretKey: keyring
server:
    replicas: ${server_replica_count}
    bootstrapExpect: ${server_replica_count}
ui:
    service:
        type: ${ui_service_type}