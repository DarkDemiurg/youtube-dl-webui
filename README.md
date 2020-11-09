# youtube-dl-webui

Another webui for youtube-dl powered by Flask.

[youtube-dl][1] is a powerful command-line based tool aims to download videos
from Youtube.com and a few more sites. However, it lacks a manager to control
and schedule all downloading tasks separately. Also, for people who like me
prefers to deploy downloading tasks on a home-server, the ability to manage
tasks remotely comes essentially.

There has been a webui for youtube available on Github, [Youtube-dl-WebUI][2].
The drawbacks of this project is that it writes in PHP and [youtube-dl][1]
writes in python. What makes things more worse is that, to use PHP, a web
server is needly inevitably. This complexes service deployment and makes it not
very 'light'.

**issues** are welcomed!

# Screenshot

![screenshot1](screen_shot/1.gif)

# Prerequisite

This project is writen under the **python 3.6**, I haven't test the codes in
any other python versions. So, I hightly recommend you to use python 3.6 to
avoid any troubles.

Also, we need **[ffmpeg](https://www.ffmpeg.org/download.html)** for post
processing. Lack of ffmpeg may case some funtions not working.

# Install

To install youtube-dl-webui, you have to firstly install [youtube-dl][1] and
[Flask][3], then simply execute the following command:

    python setup.py install

# How to use

Defaultly, youtube-dl-webui will find the configuration file in `/etc`
directory named `youtube-dl-webui.conf`. The configuration file, however,
need not to be always placed in such a place. Instead, the `-c` option is
used to point out the configuration file.

Configuration file is __json__ formatted. An example configuration file
can be found in the root directory of project.

Currently, not to much options available, use `-h` to find out all of them.

After everything is ready, simply execute:

    youtube-dl-webui -c CONFIGURATION_FILE

A server will be started locally. The default port is **5000**.

**Note**, you have to remove proxy configuration option in your config file. I
write it here for illustrating all valid config options.

# Docker image

## Install

From DockerFile

        cd /tmp
        docker build -f </path/to/Dockerfile> -t youtube-dl-webui .

## Usage

1. Run container

        docker run -d \
            --name <container_name> \
            -e PGID=<gid> \
            -e PUID=<uid> \
            -e PORT=port \
            -e CONF_FILE=<config_file_in_container> \
            -v <config_file>:<config_file_in_container> \
            -p <host_port>:<port> \
            -v <host_download_dir>:<download_dir> \
            d0u9/youtube-dl-webui


2. Automatically start container after booting

    Create `/etc/systemd/system/docker-youtube_dl_webui.service`, and fill
    with the contents below:

        [Unit]
        Description=youtube-dl downloader
        Requires=docker.service
        After=docker.service

        [Service]
        Restart=always
        ExecStart=/usr/bin/docker start -a <container_name>
        ExecStop=/usr/bin/docker stop -t 2 <container_name>

        [Install]
        WantedBy=default.target

## Default configurations

All defualt settings can be found in [this json file](https://github.com/d0u9/docker/blob/master/dockerfiles/youtube-dl-webui/default_config.json).

- Files save to: `/tmp/youtube_dl`;
- Database file location: `/tmp/youtube_dl_webui.db`;
- Log size: `10`;
- Listen address: `0.0.0.0`;
- Listen port: `5000`

---



---

[1]: https://github.com/rg3/youtube-dl
[2]: https://github.com/avignat/Youtube-dl-WebUI
[3]: https://github.com/pallets/flask
[4]: https://hub.docker.com/r/d0u9/youtube-dl-webui/

