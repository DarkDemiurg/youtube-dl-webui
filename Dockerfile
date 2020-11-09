# For ubuntu, the latest tag points to the LTS version, since that is
# recommended for general use.
FROM python:3.6-slim

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.10
RUN set -x \
	&& buildDeps=' \
		unzip \
		ca-certificates \
		dirmngr \
		wget \
		xz-utils \
		gpg \
        gpg-agent \
	' \
	&& apt-get update && apt-get install -y --no-install-recommends $buildDeps \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true

# install ffmpeg
ENV FFMPEG_URL 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz'
RUN : \
	&& mkdir -p /tmp/ffmpeg \
	&& cd /tmp/ffmpeg \
	&& wget -O ffmpeg.tar.xz "$FFMPEG_URL" \
	&& tar -xf ffmpeg.tar.xz -C . --strip-components 1 \
	&& cp ffmpeg ffprobe qt-faststart /usr/bin \
	&& cd .. \
	&& rm -fr /tmp/ffmpeg
#ffmpeg-10bit

RUN wget -O /usr/local/bin/docker-entrypoint.sh https://raw.githubusercontent.com/lubbyhst/youtube-dl-webui/master/docker-entrypoint.sh
RUN wget -O /config.json https://raw.githubusercontent.com/lubbyhst/youtube-dl-webui/master/default_config.json
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# install youtube-dl-webui
ENV YOUTUBE_DL_WEBUI_SOURCE /usr/src/youtube_dl_webui
WORKDIR $YOUTUBE_DL_WEBUI_SOURCE

RUN : \
	&& pip install --no-cache-dir youtube-dl flask \
	&& wget -O youtube-dl-webui.zip https://github.com/lubbyhst/youtube-dl-webui/archive/0.2.2.zip \
	&& unzip youtube-dl-webui.zip \
	&& cd youtube-dl-webui*/ \
	&& cp -r ./* $YOUTUBE_DL_WEBUI_SOURCE/ \
	&& ln -s $YOUTUBE_DL_WEBUI_SOURCE/example_config.json /etc/youtube-dl-webui.json \
	&& cd .. && rm -rf youtube-dl-webui* \
	&& apt-get purge -y --auto-remove wget unzip dirmngr \
	&& rm -fr /var/lib/apt/lists/*

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["python", "-m", "youtube_dl_webui"]
