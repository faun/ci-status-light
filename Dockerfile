FROM acencini/rpi-python-serial-wiringpi
RUN apt-get update && apt-get install -yq ca-certificates libidn11 openssl wget bzip2 tar libtool flex bison dh-autoreconf

RUN (cd /tmp; wget -O jq.tar.gz https://github.com/stedolan/jq/releases/download/jq-1.5/jq-1.5.tar.gz) \
    && (cd /tmp; mkdir jq; tar -xf jq.tar.gz -C jq --strip-components=1; rm jq.tar.gz) \
    && (cd /tmp/jq/; autoreconf -i && ./configure --enable-all-static --disable-maintainer-mode && make -j) \
    && mkdir -p /tmp/bin/ \
    && ls /tmp/jq \
    && cp /tmp/jq/jq /usr/local/bin/

ENTRYPOINT /data/ci-status.sh
COPY . /data/
RUN chmod +x /data/ci-status.sh
