#!/bin/bash

set -e
# 获取端口名
result=$(kubectl get service faraday-service --output='jsonpath="{.spec.ports[0].nodePort}"' -n development)
echo $result
echo '
server {
    listen 80;
    server_name kubernetes.staffjoy-v2.local;
    location / {
        proxy_pass http://localhost:8001;
    }
}

server {
    listen 80;
    server_name *.staffjoy-v2.local staffjoy-v2.local;

    location / {
        proxy_pass http://127.0.0.1:55004;
        proxy_set_header Host            $host;
        proxy_set_header X-Forwarded-For $remote_addr;
    }
}

' | sudo tee  /opt/homebrew/etc/nginx/servers/staffjoyv2.conf

nginx
