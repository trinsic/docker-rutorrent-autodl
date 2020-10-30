# Docker rutorrent-autodl

Based on linuxserver/rutorrent

## Usage

```sh
docker create --name=rutorrent-autodl \
-v <path to data>:/config \
-p 5000:80 \
trinsic/rutorrent-autodl
```

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it rutorrent /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```sh
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application

Webui can be found at `<your-ip>:5000` , configuration files for rtorrent are in /config/rtorrent, php in config/php and for the webui in /config/rutorrent/settings.

`Settings, changed by the user through the "Settings" panel in ruTorrent, are valid until rtorrent restart. After which all settings will be set according to the rtorrent config file (/config/rtorrent/rtorrent.rc),this is a limitation of the actual apps themselves.`

** Important note for unraid users or those running services such as a webserver on port 80, change port 80 assignment **

** The Port Assignments and configuration folder structure has been changed from the previous ubuntu based versions of this container and we recommend a clean install **

## Info

* Shell access whilst the container is running: `docker exec -it rutorrent /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f rutorrent`
