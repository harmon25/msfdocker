FROM kalilinux/kali-linux-docker
MAINTAINER nomraharmon@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get -y dist-upgrade && apt-get clean

RUN apt-get -y install metasploit-framework && apt-get clean

COPY ./init.sh /init.sh

ENV MSF_DATABASE_CONFIG /etc/database.yml
ENV PGPASSFILE /.pgpass

EXPOSE 55555

CMD ["/init.sh"]