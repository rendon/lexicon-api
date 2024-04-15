# Lexeme API

## Run in container
```sh
docker build -t lexeme-api .
docker run -d --name lexeme-api -p 3000:3000 -e SECRET_KEY_BASE=<secret-key> lexeme-api
```

## Run server over HTTPS
See [Run rails over-SSL](https://letmethink.blog/index.php/2023/09/14/web-development-notes/#run-rails-over-ssl-locally)
