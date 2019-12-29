FROM ubuntu
RUN apt-get -y update \
COPY /scripts/* /
