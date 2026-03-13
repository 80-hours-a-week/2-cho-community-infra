#!/bin/bash
set -euxo pipefail

# HAProxy 설치
dnf install -y haproxy

# HAProxy 설정 작성
cat > /etc/haproxy/haproxy.cfg << 'EOF'
global
    log /dev/log local0
    maxconn 2048

defaults
    log     global
    mode    tcp
    option  tcplog
    timeout connect 5s
    timeout client  30s
    timeout server  30s
    retries 3

frontend k8s_api
    bind *:6443
    default_backend k8s_masters

backend k8s_masters
    option httpchk GET /healthz
    http-check expect status 200
    balance roundrobin
${master_backends}

frontend stats
    bind *:9000
    mode http
    stats enable
    stats uri /stats
    stats refresh 10s
EOF

systemctl enable --now haproxy
