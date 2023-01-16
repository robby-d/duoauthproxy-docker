# duoauthproxy-docker
Barebones docker image of Duo's duoauthproxy

## Installation

Make sure you have Docker and Docker Compose installed on your system.

Copy the `conf/authproxy.cfg.dist` file to `conf/authproxy.cfg` and customize it to your needs according to the [duoauthproxy reference](https://duo.com/docs/authproxy-reference). SSL certificates and private keys can be placed in the `conf/ssl` directory.

Once created, set the proper permissions:
```
sudo chown root:35505 conf/authproxy.cfg
sudo chmod 640 conf/authproxy.cfg
```

Then, build the image:
```
docker compose build
```

## Testing

Run `docker compose up` to make sure the container starts and operates properly.

## Operation

### Normal operation

Once everything looks good, just run `docker compose up -d`. The container should then start up (and be set to restart automatically if the host machine is rebooted). Logging output is available through `docker logs`.

### Changing logging output

Note that by default the docker container logs will show `duoauthproxy` output. Unfortunately this output is limited to debug-level logging due to limitations in the `duoauthproxy` code. If you'd like to rather log to files in the `log` directory as normal verbosity, just change the line reading:
```
CMD ["/opt/duoauthproxy/bin/authproxy", "--logging-insecure"]
```
To:
```
CMD ["/opt/duoauthproxy/bin/authproxy"]
```

And then run `docker compose build` and `docker compose restart`.
