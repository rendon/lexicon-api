# Lexeme API

## Develop
Run the server:
```sh
bin/rails server
```

## Run server over HTTPS locally
See [Run rails over-SSL](https://letmethink.blog/index.php/2023/09/14/web-development-notes/#run-rails-over-ssl-locally)

## Deploy to production
This service runs in a docker container proxied by an Apache server with TLS certificates. Here's what you need to do to launch the service correctly:

TODO: Link to blog post that shows how to set up reverse proxy.

1. Copy Let's Encrypt certificates to the `certs/` folder
```sh
sudo cp /etc/letsencrypt/live/rafaelrendon.io/privkey.pem certs/private.key
sudo cp /etc/letsencrypt/live/rafaelrendon.io/cert.pem certs/cert.crt

chmod 644 certs/*
```

2. Build image and run container
```sh
docker build -t lexeme-api .
docker run -d --name lexeme-api -p 3001:3001 -e SECRET_KEY_BASE=<secret-key> lexeme-api
```
