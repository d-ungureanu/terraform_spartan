#!/usr/bin/env bash

sudo apt-get -y update
sudo apt-get -y install nginx
sudo systemctl start nginx
sudo mv /etc/nginx/sites-available/default .
sudo rm /etc/nginx/sites-enabled/default
sudo tee -a /etc/nginx/sites-available/spartan_web << END
upstream spartan_servers {
        server web1.dungureanu.devops106:5000;
        server web2.dungureanu.devops106:5000;
        server web3.dungureanu.devops106:5000;
        server web4.dungureanu.devops106:5000;
}

server {
        listen 80;
        server_name _;
        location / {
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_pass http://spartan_servers;
        }
}
END
sudo ln -s /etc/nginx/sites-available/spartan_web /etc/nginx/sites-enabled/
sudo systemctl restart nginx
sudo systemctl enable nginx