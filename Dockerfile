ARG UBUNTU_RELEASE=22.04
FROM ubuntu:${UBUNTU_RELEASE}
# yes got to repeat this line ... after FROM all is forgotten
ARG UBUNTU_RELEASE=22.04
ENV UBUNTU_RELEASE=${UBUNTU_RELEASE}
STOPSIGNAL SIGRTMIN+3
COPY build /build
RUN cd /build; sh start.sh
RUN curl https://www.cendio.com/downloads/server/tl-4.18.0-server.zip > tl.zip; unzip tl.zip;rm tl.zip; cd tl-*-server/packages;rm *rpm *_i386.deb;dpkg --install *.deb; cd /;rm -rf /tl-*-server; /opt/thinlinc/sbin/tl-setup -a /build/tl-setup-answers; rm -rf /build
#RUN curl https://www.cendio.com/downloads/beta/tl-4.13.0beta1-server.zip > tl.zip; unzip tl.zip;rm tl.zip; cd tl-*-server/packages;rm *rpm *_i386.deb;dpkg --install *.deb; cd /;rm -rf /tl-*-server; /opt/thinlinc/sbin/tl-setup -a /build/tl-setup-answers; rm -rf /build
# when the image actually runs, then systemd will be runnnig
# so put things in order again ...
EXPOSE 22/tcp
COPY tlcfg.sh /sbin/tlcfg
RUN chmod 755 /sbin/tlcfg
CMD ["/sbin/init"]
