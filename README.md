# Dockerfile for Easycwmp - TR069 client

Automatically connect to GenieACS at networks name `genieacs`, standard port
`7547`.

Tested with the offical GenieACS docker: `drumsergio/genieacs`.


### Run the Docker image

Simply issue this command to start `Easycwmp`.

```bash
docker run -it --net <acs-network-bridge> gaimande/easycwmp
```

You can check the <acs-networks-bridge> name from the `docker networks ls` command.
