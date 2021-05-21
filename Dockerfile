FROM ubuntu:rolling
RUN apt-get -y update
RUN apt-get -y install wget nano gnupg
RUN wget -O /usr/share/keyrings/gpg-pub-moritzbunkus.gpg https://mkvtoolnix.download/gpg-pub-moritzbunkus.gpg
RUN apt-get update
RUN apt -y install mkvtoolnix mkvtoolnix-gui
RUN mkdir /scripts
COPY scripts/ /scripts
