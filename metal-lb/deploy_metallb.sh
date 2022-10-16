#!/bin/bash
addresses=$(docker network inspect kind | jq '.[].IPAM | .Config | .[0].Subnet' | cut -d \" -f 2)

net_range=$(echo $addresses | awk '{print $0}' | cut -b 1-8)

helm repo add metallb https://metallb.github.io/metallb


helm upgrade --install metallb metallb/metallb \
  --version 0.11.0 \
  --create-namespace \
  --namespace metallb-system \
  --set "configInline.address-pools[0].addresses[0]=""$net_range".10-"$net_range".20"" \
  --set "configInline.address-pools[0].name=default" \
  --set "configInline.address-pools[0].protocol=layer2" \
  --set controller.nodeSelector.loadbalancer=enabled \
  --set "controller.tolerations[0].key=node-role.kubernetes.io/master" \
  --set "controller.tolerations[0].effect=NoSchedule" \
  --set speaker.tolerateMaster=true \
  --set speaker.nodeSelector.loadbalancer=enabled

kubectl get nodes > /tmp/saida.txt

namenode=$(awk '/control-plane/ {print $1}' /tmp/saida.txt)

kubectl label nodes $namenode loadbalancer=enabled