FROM bcit/alpine:3.11

LABEL maintainer="jesse@weisner.ca, chriswood.ca@gmail.com"
LABEL build_id="1605897505"

# Add docker-entrypoint script base
ADD https://github.com/itsbcit/docker-entrypoint/releases/download/v1.5/docker-entrypoint.tar.gz /docker-entrypoint.tar.gz
RUN tar zxvf docker-entrypoint.tar.gz && rm -f docker-entrypoint.tar.gz \
 && chmod -R 555 /docker-entrypoint.* \
 && chmod 664 /etc/passwd /etc/group /etc/shadow \
 && chown 0:0 /etc/shadow \
 && chmod 775 /etc

# Add dockerize
ADD https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-alpine-linux-amd64-v0.6.1.tar.gz /dockerize.tar.gz
RUN [ -d /usr/local/bin ] || mkdir -p /usr/local/bin \
 && tar zxf /dockerize.tar.gz -C /usr/local/bin \
 && chown 0:0 /usr/local/bin/dockerize \
 && chmod 0555 /usr/local/bin/dockerize \
 && rm -f /dockerize.tar.gz

ENV DOCKERIZE_ENV production

# Add Tini
ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini-static-amd64 /tini
RUN chmod +x /tini \
 && ln -s /tini /sbin/tini 

RUN apk add --no-cache \
    lua \
    luarocks

RUN ln -s luarocks-5.1 /usr/bin/luarocks

ENTRYPOINT ["/tini", "--", "/docker-entrypoint.sh"]
CMD [ "lua" ]
