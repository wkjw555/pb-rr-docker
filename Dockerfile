FROM debian:jessie

WORKDIR /opt/pgbouncer

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y -q \
	libevent-dev \
	libssl-dev \
	git	\
	libtool	\
	python-dev \
	autotools-dev \
	automake \
	pkg-config \
	build-essential

RUN git clone https://github.com/pgbouncer/pgbouncer.git --branch "pgbouncer_1_12_0" /opt/pgbouncer && \
	git clone https://github.com/awslabs/pgbouncer-rr-patch.git /opt/pgbouncer-rr-patch && \
	cd /opt/pgbouncer-rr-patch && ./install-pgbouncer-rr-patch.sh /opt/pgbouncer && \
	mkdir /home/pgbouncer && \
	useradd -m pgbouncer && chown -R pgbouncer:pgbouncer /home/pgbouncer

RUN git submodule init && git submodule update \
	&& ./autogen.sh && ./configure && make && make install

USER pgbouncer
CMD ["/usr/local/bin/pgbouncer", "/home/pgbouncer/conf/pgbouncer.ini"]
