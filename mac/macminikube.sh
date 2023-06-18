#!/bin/bash

# VERSIONS
MINIKUBE_VERSION=1.25.2
KUBECTL_CLI_VERSION=1.23.6



## DEPS
# sudo apt install -y -q  conntrack


# We need to run a local registry - k8s cannot just pull locally

# $FORCE_UPDATE && [ -f /usr/local/bin/minikube ] && minikube delete --all --purge && echo "[x] Force update flag used. Uninstalling minikube and all files";
# $FORCE_UPDATE && [ -f /usr/local/bin/minikube ] && sudo minikube delete && sudo rm -rf /usr/local/bin/minikube && echo "[x] Force update flag used. Removing existing version of minikube";
# $FORCE_UPDATE && [ -f /usr/local/bin/kubectl ] && sudo rm -rf /usr/local/bin/kubectl && echo "[x] Force update flag used. Removing existing version of kubectl";


# download and install kubectl ...
# Latest stable: https://github.com/kubernetes/kubernetes/releases | https://storage.googleapis.com/kubernetes-release/release/stable.txt
# if [ ! -f "/usr/local/bin/kubectl" ] ; then
#     echo "[x] Downloading kubectl ${KUBECTL_CLI_VERSION}...";
#     curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_CLI_VERSION}/bin/linux/amd64/kubectl && sudo mv kubectl /usr/local/bin/ && sudo chmod +x /usr/local/bin/kubectl && sudo chown root:root /usr/local/bin/kubectl;
# fi


# ... and minikube
# Latest stable: https://github.com/kubernetes/minikube/releases
# if [ ! -f "/usr/local/bin/minikube" ] ; then
#     echo "[x] Downloading minikube ${MINIKUBE_VERSION}...";
#     curl -Lo minikube https://storage.googleapis.com/minikube/releases/v${MINIKUBE_VERSION}/minikube-linux-amd64 && sudo mv minikube /usr/local/bin/ && sudo chmod +x /usr/local/bin/minikube && sudo chown root:root /usr/local/bin/minikube;
# fi


# Clean temp stuff.
# sudo rm -rf /tmp/juju* /tmp/minikube*;


minikube start \
    --image-mirror-country='cn' \
    --kubernetes-version=v${KUBECTL_CLI_VERSION} \
    --driver=docker \
    --bootstrapper=kubeadm \
    --dns-domain="cluster.local" \
    --service-cluster-ip-range="10.0.0.0/12" \
    --extra-config="kubelet.cluster-dns=10.0.0.10" \
    --docker-opt "registry-mirror=https://dockerproxy.com" \
    --static-ip "10.0.2.15" \



# either use sudo on all kubectl commands, or chown/chgrp to your user
# sudo chown -R ${USER} ${HOME}/.kube ${HOME}/.minikube


# this will write over any previous configuration)
# wait for the cluster to become ready/accessible via kubectl
echo -e -n " [ ] Waiting for master components to start...";
JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}';
until kubectl get nodes -o jsonpath="$JSONPATH" 2>&1 | grep -q "Ready=True"; do
    echo -n ".";
    sleep 1;
done

# registry
minikube addons enable registry
docker run --rm -it --network=host alpine ash -c "apk add socat && socat TCP-LISTEN:5000,reuseaddr,fork TCP:$(minikube ip):5000"



minikube kubectl -- kubectl cluster-info

minikube kubectl -- config set-cluster staffjoy-dev --server=https://10.0.2.15:8443 --certificate-authority=/Users/ljh/.minikube/ca.crt
minikube kubectl -- config set-context staffjoy-dev --cluster=staffjoy-dev --user=minikube
minikube kubectl  -- config use-context staffjoy-dev

minikube kubectl  --  create namespace development

minikube kubectl  --  --namespace=development create -R -f /Users/ljh/it/source/new/StaffjoyV2/ci/k8s/development/infrastructure/app-mysql

minikube kubectl  --  --context minikube proxy &>/dev/null &
# enables dashboard
minikube addons enable dashboard
minikube dashboard &>/dev/null &

