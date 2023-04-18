FROM debian:bullseye

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

RUN git clone -b pgbouncer_1_12_0 https://github.com/pgbouncer/pgbouncer.git /opt/pgbouncer && \
	git clone https://github.com/awslabs/pgbouncer-rr-patch.git /opt/pgbouncer-rr-patch && \
	cd /opt/pgbouncer-rr-patch && ./install-pgbouncer-rr-patch.sh /opt/pgbouncer && \
	mkdir /etc/pgbouncer-rr && \
	useradd -m pgbouncer && chown -R pgbouncer:pgbouncer /etc/pgbouncer-rr

RUN git submodule init && git submodule update \
	&& ./autogen.sh && ./configure && make && make install

USER pgbouncer
CMD ["/usr/local/bin/pgbouncer", "/home/pgbouncer/conf/pgbouncer.ini"]
