#!/bin/bash

if [ -z $REGISTRY_ADDRESS ]; then
  echo "No local registry address set"
  exit -t
fi

# redirect local docker registry to host's registry
iptables -t nat -A OUTPUT -p tcp --dport 5000 -j DNAT \
  --to-destination $REGISTRY_ADDRESS
iptables -t nat -A POSTROUTING -j MASQUERADE
