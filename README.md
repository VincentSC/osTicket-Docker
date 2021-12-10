This is the docker version to migrate your osTicket to Docker.

- `update.sh` grabs the latest version of osTicket from Github
- `Dockerfile` builds a new Docker using Apache
- `docker-compose` uses nginx-proxy.

If you want to start a new osTicket, make sure you temporarily avoid the removing of the setup-dir in `update.sh`.

To update:
- run `update.sh`. Check for errors.
- run docker-compose up -d --build
- wait, as this takes several minutes

This docker is used in production. I'm sharing these files, so I can learn while helping others. This means that e.g. nginx-proxy will remain the default, but I'm totally open to make overrides for other proxies.
