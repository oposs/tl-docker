ARG UBUNTU_RELEASE=20.04
FROM ubuntu:${UBUNTU_RELEASE}
# yes got to repeat this line ... after FROM all is forgotten
ARG UBUNTU_RELEASE=20.04
ENV UBUNTU_RELEASE ${UBUNTU_RELEASE}
STOPSIGNAL SIGRTMIN+3
COPY build /build
RUN cd /build; sh start.sh
RUN curl https://www.cendio.com/downloads/server/download.py > tl.zip; unzip tl.zip;rm tl.zip; cd tl-*-server/packages;rm *rpm *_i386.deb;dpkg --install *.deb; cd /;rm -rf /tl-*-server; /opt/thinlinc/sbin/tl-setup -a /build/tl-setup-answers; rm -rf /build
# when the image actually runs, then systemd will be runnnig
# so put things in order again ...
EXPOSE 22/tcp
COPY tlcfg.sh /sbin/tlcfg
RUN chmod 755 /sbin/tlcfg
CMD ["/sbin/init"]