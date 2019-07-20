#!/bin/bash

PORT=5000

if [ -z $REGISTRY_ADDRESS ]; then
  echo "No local registry address set"
  exit 1
fi

# enable localnet redirection
sysctl -w net.ipv4.conf.all.route_localnet=1

# redirect local docker registry to host's registry
iptables -t nat -A OUTPUT -p tcp --dport $PORT -j DNAT \
  --to-destination $REGISTRY_ADDRESS
iptables -t nat -A POSTROUTING -j MASQUERADE

echo "Setup redirection to host registry on port $PORT"
