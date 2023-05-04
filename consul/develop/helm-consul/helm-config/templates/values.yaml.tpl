global:
    datacenter: ${datacenter_name}
    image: ${image_version}
    acls:
        manageSystemACLs: ${manage_system_acl}
    gossipEncryption:
        autoGenerate: false
        secretName: consul-gossip-encrypt-keyring
        secretKey: keyring
    tls:
        enabled: ${enable_tls}
        enableAutoEncrypt: ${enable_auto_encrypt}
        caCert:
            secretName: ${ca_cert_secret_name}
            secretKey: ${ca_cert_secret_key}
        caKey:
            secretName: ${ca_key_secret_name}
            secretKey: ${ca_key_secret_key}
server:
    replicas: ${server_replica_count}
    bootstrapExpect: ${server_replica_count}
ui:
    service:
        type: ${ui_service_type}