# snippetbox

A web app for storing text snippets, based on the book Let's Go by Alex Edwards. Go, MySQL, signup and login.

Requires a `snippetbox` database and TLS certificates at `tls/cert.pem` and `tls/key.pem`.

```sh
make run ARGS="-dsn='web:pass@/snippetbox?parseTime=true'"
```

Open https://localhost:4000.
