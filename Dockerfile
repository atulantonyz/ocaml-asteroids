FROM ocaml/opam2:debian-10-ocaml-4.08

RUN sudo mkdir /app
WORKDIR /app
ADD . /app/

# Debian 10 (buster) left the live mirrors; packages now live on archive.debian.org.
RUN sudo sed -i \
      -e 's|deb.debian.org/debian|archive.debian.org/debian|g' \
      -e 's|security.debian.org/debian-security|archive.debian.org/debian-security|g' \
      /etc/apt/sources.list \
 && sudo sed -i '/buster-updates/d' /etc/apt/sources.list \
 && sudo apt-get -o Acquire::Check-Valid-Until=false update
RUN sudo apt-get install m4 freeglut3-dev libglu1-mesa-dev mesa-common-dev -y

RUN opam install lablgl obuild core
