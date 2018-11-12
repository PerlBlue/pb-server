# pb-server
Server code for the PerlBlue application

Checkout the YNAP Web-Socket demonstration code.
```bash
$ git checkout YNAP
```
Install `docker` on your local machine

https://docs.docker.com/docker-for-mac/install/

Then run all the docker components.

```bash
$ docker-compose up
```

This will download and run all the docker components needed to run the PerlBlue server codes including the components needed to run the YNAP web-socket demonstration code.

This will expose the port `8090` on your localhost to be used by the front-end code.
