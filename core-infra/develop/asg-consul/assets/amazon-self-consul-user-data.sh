#!/bin/bash
set -ex
exec > >(tee /var/log/userdata.log|logger -t userdata)

yum install wget unzip -y
cd /tmp && wget https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip -o /tmp/consul.zip
unzip /tmp/consul_${consul_version}_linux_amd64.zip -d /tmp
mv /tmp/consul /usr/local/bin/consul

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4 -H "X-aws-ec2-metadata-token: $TOKEN")

mkdir -p /etc/consul.d
echo "echo $PRIVATE_IP" > /etc/consul.d/get_ip.sh
chmod a+x /etc/consul.d/get_ip.sh

cat > /etc/consul.d/consul.hcl << EOF 
${consul_hcl_file_content}
EOF

cat > /usr/lib/systemd/system/consul.service << EOF 
bind_addr = $PRIVATE_IP
${consul_service_file_content}
EOF

su "ec2-user" -c "sudo systemctl start consul"
