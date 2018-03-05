FROM centos:7
MAINTAINER Johan Denoyer <johan@johandenoyer.fr>
ENV MALLOC_CHECK_ 0
ENV LD_LIBRARY_PATH /usr/lib

RUN yum -y install openssl-devel
RUN yum -y downgrade openssl-devel-1.0.2k-8.el7.x86_64
RUN yum -y install wget tar make cmake gcc gcc-c++ libedit-devel flex bison

RUN cd /tmp && \
    wget https://www.shrew.net/download/ike/ike-2.2.1-release.tgz && \
    tar -xzf ike-* && \
    cd ike* && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DQTGUI=NO -DETCDIR=/etc -DNATT=YES && \
    make && \
    make install && \
    make install && \
    rm -rf /tmp/ike*

RUN mv /etc/iked.conf.sample /etc/iked.conf

VOLUME /sites
WORKDIR /sites

COPY start-iked.sh /usr/local/bin/start-iked.sh
ENTRYPOINT ["/usr/local/bin/start-iked.sh"]
