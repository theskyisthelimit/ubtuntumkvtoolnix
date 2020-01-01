FROM ubuntu
RUN apt-get -y update
RUN apt-get -y install wget nano gnupg python
RUN wget -q -O - https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | apt-key add
RUN apt-get update
RUN apt -y install mkvtoolnix mkvtoolnix-gui
