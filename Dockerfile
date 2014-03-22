FROM ubuntu:precise

RUN ( nc -zw 8 172.17.42.1 3142 && echo 'Acquire::http { Proxy "http://172.17.42.1:3142"; };' > /etc/apt/apt.conf.d/01proxy ) || true
RUN apt-get update -y
RUN apt-get install -y ca-certificates python-setuptools wget

RUN easy_install supervisor

RUN wget -qO- 'https://dpb587-scs-utils.s3.amazonaws.com/logstash-forwarder' > /usr/bin/logstash-forwarder && chmod +x /usr/bin/logstash-forwarder
RUN wget -qO- 'https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework' > /usr/bin/pipework && chmod +x /usr/bin/pipework

RUN useradd -M -s /bin/false -u 1010 -U scs

RUN mkdir /etc/scs
RUN mkdir /etc/supervisor.d
RUN mkdir /var/log/scs-logs
RUN mkdir /var/log/supervisor
RUN mkdir /var/run/supervisor

ADD . /
VOLUME /etc/scs-runtime

ENTRYPOINT [ "/usr/bin/scs-runtime-exec" ]
