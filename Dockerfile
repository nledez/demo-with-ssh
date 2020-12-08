FROM nginx:1.16

RUN apt-get update && apt-get -y dist-upgrade && apt-get install -y openssh-server apache2 procps supervisor && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor
RUN useradd demo && echo 'demo:DemoPassword35!' | chpasswd && mkdir -p /home/demo/.ssh && chown -R demo:demo /home/demo
RUN openssl genrsa 4096 > /etc/nginx/tls-private-key.pem && \
    openssl req -new -sha256 -key /etc/nginx/tls-private-key.pem -subj "/CN=localhost" > /etc/nginx/tls-csr.pem && \
    openssl x509 -in /etc/nginx/tls-csr.pem -out /etc/nginx/tls-certificate.pem -req -signkey /etc/nginx/tls-private-key.pem -days 365

COPY nginx_default.conf /etc/nginx/conf.d/default.conf
COPY static-html-directory /usr/share/nginx/html
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY id_rsa_demo.pub /home/demo/.ssh/authorized_keys

RUN sed -i 's@^@restrict,command="/bin/hostname" @' /home/demo/.ssh/authorized_keys

EXPOSE 22 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
