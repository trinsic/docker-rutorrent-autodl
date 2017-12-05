FROM lsiobase/alpine:3.6
MAINTAINER sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# copy patches
COPY patches/ /defaults/patches/

# install packages
RUN \
 apk add --no-cache \
	ca-certificates \
	curl \
	fcgi \
	ffmpeg \
	geoip \
	gzip \
	logrotate \
	nginx \
	php7 \
	php7-cgi \
	php7-fpm \
	php7-json  \
	php7-mbstring \
	php7-pear \
	php7-sockets \
	rtorrent \
	screen \
	tar \
	unrar \
	unzip \
	wget \
	git \
	zlib \
	zip && \

# Mediainfo from edge
 apk add --no-cache \
	--repository http://nl.alpinelinux.org/alpine/edge/community \
	mediainfo && \

# Autodl dependencies from edge
 apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/main \
	perl \
	perl-archive-zip \
	perl-net-ssleay \
	perl-html-parser \
	perl-digest-sha1 \
	perl-json \
	irssi \
	irssi-perl && \

 apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/community \
	perl-xml-libxml && \

 apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/testing \
	perl-json-xs && \

# install webui
 mkdir -p \
	/usr/share/webapps/rutorrent \
	/defaults/rutorrent-conf && \
 curl -o \
	/tmp/rutorrent.tar.gz -L \
	"https://github.com/Novik/ruTorrent/archive/master.tar.gz" && \
 tar xf \
	/tmp/rutorrent.tar.gz -C \
	/usr/share/webapps/rutorrent --strip-components=1 && \
 mv /usr/share/webapps/rutorrent/conf/* \
	/defaults/rutorrent-conf/ && \
 rm -rf \
	/defaults/rutorrent-conf/users && \

# patch snoopy.inc for rss fix
 cd /usr/share/webapps/rutorrent/php && \
 patch < /defaults/patches/snoopy.patch && \

# get additional rutorrent theme
 git clone git://github.com/phlooo/ruTorrent-MaterialDesign.git /usr/share/webapps/rutorrent/plugins/theme/themes/MaterialDesign && \

# cleanup
 rm -rf \
	/etc/nginx/conf.d/default.conf \
	/tmp/* && \

# fix logrotate
 sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config /downloads
