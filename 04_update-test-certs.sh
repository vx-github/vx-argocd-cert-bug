#!/bin/bash
interval=60

echo "Generate and apply 5 Selfsigned Certs with $interval seconds between"
echo
sleep 2

for n in 1 2 3 4 5
do
  o="Argo CD Cert Test number ${n}"
  echo "Generating Selfsigned Cert with Organization:  $o"
  echo
	
cat > cert/cert.config << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE

[ req ]
default_bits = 2048
default_md = sha256
prompt = no
encrypt_key = no
distinguished_name = dn
req_extensions = req_ext

[ dn ]
C = NL
O = Argo CD Cert Test number ${n}
CN = localhost

[ req_ext ]
subjectAltName = DNS:localhost
EOF


  openssl req -new -newkey rsa:2048 -days 10 -nodes -x509 -keyout cert/key.pem -out cert/cert.pem -config cert/cert.config
  echo
  date "+%Y-%m-%d %H:%M:%S"
  openssl x509 -in cert/cert.pem -noout -subject -dates -serial | egrep "^not|^subject|^serial"
  echo
  kubectl create -n argocd secret tls argocd-server-tls --cert=cert/cert.pem --key=cert/key.pem --dry-run=client -o yaml | kubectl apply -f -
  echo

  if [[ $n < 5 ]]
  then
    echo "---------------------------------------------------"
    echo "Waiting $interval seconds for updating 'argocd-server-tls'"
    echo
    sleep $interval	
  fi
done
