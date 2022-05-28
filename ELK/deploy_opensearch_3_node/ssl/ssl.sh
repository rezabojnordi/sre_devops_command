#!/bin/sh
# Root CA
openssl genrsa -out root-ca-key.pem 4096
openssl req -new -x509 -sha256 -key root-ca-key.pem -subj "/C=CA/ST=ARIA/L=TEHRAN/O=ORG/OU=UNIT/CN=CA" -out root-ca.pem -days 3650
# Admin cert
openssl genrsa -out admin-key-temp.pem 4096
openssl pkcs8 -inform PEM -outform PEM -in admin-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out admin-key.pem
openssl req -new -key admin-key.pem -subj "/C=CA/ST=ARIA/L=TEHRAN/O=ORG/OU=UNIT/CN=admin" -out admin.csr
openssl x509 -req -in admin.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out admin.pem -days 3650
# Node cert 1
openssl genrsa -out node1-key-temp.pem 4096
openssl pkcs8 -inform PEM -outform PEM -in node1-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out node1-key.pem
openssl req -new -key node1-key.pem -subj "/C=CA/ST=ARIA/L=TEHRAN/O=ORG/OU=UNIT/CN=opensearch-node1" -out node1.csr
openssl x509 -req -in node1.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out node1.pem -days 3650
# Node cert 2
openssl genrsa -out node2-key-temp.pem 4096
openssl pkcs8 -inform PEM -outform PEM -in node2-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out node2-key.pem
openssl req -new -key node2-key.pem -subj "/C=CA/ST=ARIA/L=TEHRAN/O=ORG/OU=UNIT/CN=opensearch-node2" -out node2.csr
openssl x509 -req -in node2.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out node2.pem -days 3650
# Node cert 3
openssl genrsa -out node3-key-temp.pem 4096
openssl pkcs8 -inform PEM -outform PEM -in node3-key-temp.pem -topk8 -nocrypt -v1 PBE-SHA1-3DES -out node3-key.pem
openssl req -new -key node3-key.pem -subj "/C=CA/ST=ARIA/L=TEHRAN/O=ORG/OU=UNIT/CN=opensearch-node3" -out node3.csr
openssl x509 -req -in node3.csr -CA root-ca.pem -CAkey root-ca-key.pem -CAcreateserial -sha256 -out node3.pem -days 3650
# Cleanup
rm admin-key-temp.pem
rm admin.csr
rm node1-key-temp.pem
rm node1.csr
rm node2-key-temp.pem
rm node2.csr
rm node3-key-temp.pem
rm node3.csr

