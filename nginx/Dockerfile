# Pull in the from the official nginx image.
FROM nginx:1.10

LABEL maintainer "Charlie McClung <charlie@cmr1.com>"

ENV NGINX_INSTALL /etc/nginx

RUN rm $NGINX_INSTALL/conf.d/* && mkdir -p $NGINX_INSTALL/certs

COPY conf.d/*.conf $NGINX_INSTALL/conf.d/
