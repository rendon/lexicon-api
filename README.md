# Lexeme API

## Run in container
```sh
docker build -t lexeme-api .
docker run -d --name lexeme-api -p 3000:3000 -e SECRET_KEY_BASE=<secret-key> lexeme-api
```

