Build and run
=============

```
ssh-keygen -t rsa -b 4096 -C "demo-rsa-key" -f ./id_rsa_demo -N ''

docker build -t nledez/demo-with-ssh .

docker run -it -p 32722:22 -p 32780:80 -p 32443:443 nledez/demo-with-ssh

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 32722 -i ./id_rsa_demo demo@127.0.0.1
curl http://127.0.0.1:32780/
curl -k https://127.0.0.1:32443/
```
