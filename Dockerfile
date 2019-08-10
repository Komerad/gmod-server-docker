FROM ubuntu:18.04

# Default ENVARS
ARG MAP_DIR=./gmod_maps
ARG GMOD_ADDON_DIR=./gmod_addons

ARG GAME_NAME=garrysmod
ARG GAME_APPID=4020
ARG GAME_BASE_APPID=205
ARG GAME_INSTALL_CSS=1
ARG GAME_IS_CUSTOM=0
ARG GAME_CUSTOM_URL=change_me
ARG GAME_CUSTOM_URL2=change_me
ARG GAME_CUSTOM_MULTIDOWNLOAD=0
ARG SERVER_PORT=27015

RUN echo "Selected game Name: ${GAME_NAME}"
RUN echo "Selected appid: ${GAME_APPID}"
RUN echo "Install CSS alongside current game?: ${GAME_INSTALL_CSS}"
RUN echo "Is game custom?: ${GAME_IS_CUSTOM}"

RUN dpkg --add-architecture i386

RUN apt-get -y update

RUN apt-get -y dist-upgrade

RUN apt-get -y install lib32gcc1

RUN apt-get -y install lib32tinfo5

RUN apt-get -y install screen

RUN echo steam steam/question select "I AGREE" | debconf-set-selections
RUN echo steam steam/license note '' | debconf-set-selections

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install steamcmd

RUN cd ~

RUN ln -s /usr/games/steamcmd steamcmd

RUN apt-get -y install --reinstall ca-certificates

RUN if [ ${GAME_IS_CUSTOM} = 0 ]; then ./steamcmd +login anonymous +force_install_dir /${GAME_NAME}-base +app_update ${GAME_APPID} validate +quit; fi

RUN if [ ${GAME_IS_CUSTOM} = 1 ]; then ./steamcmd +login anonymous +force_install_dir /${GAME_NAME}-base +app_update 205 validate +quit; fi

RUN if [ ${GAME_IS_CUSTOM} = 1 ]; then ./steamcmd +login anonymous +force_install_dir /${GAME_NAME}-base +app_update ${GAME_BASE_APPID} validate +quit; fi

RUN if [ ${GAME_INSTALL_CSS} = 1 ]; then ./steamcmd +login anonymous +force_install_dir /css-assets-base +app_update 232330 validate +quit; fi

EXPOSE ${SERVER_PORT}/udp

WORKDIR /${GAME_NAME}-base

RUN cd /${GAME_NAME}-base

RUN if [ ${GAME_IS_CUSTOM} = 1 ]; then apt-get -y install wget; fi

RUN if [ ${GAME_IS_CUSTOM} = 1 ]; then apt-get -y install zip; fi

RUN if [ ${GAME_IS_CUSTOM} = 1 ]; then wget -O custom_content_package1.zip -d /${GAME_NAME}-base ${GAME_CUSTOM_URL} || true; fi

RUN if [ ${GAME_IS_CUSTOM} = 1 ]; then unzip custom_content_package1.zip; fi

RUN if [ ${GAME_CUSTOM_MULTIDOWNLOAD} = 1 ]; then wget -O custom_content_package2.zip -d /${GAME_NAME}-base ${GAME_CUSTOM_URL2} || true; fi

RUN if [ ${GAME_CUSTOM_MULTIDOWNLOAD} = 1 ]; then echo "A" | unzip custom_content_package2.zip; fi

RUN chmod 777 ./srcds_run

ADD mount.cfg /${GAME_NAME}-base/${GAME_NAME}/cfg/mount.cfg

ADD server.cfg /${GAME_NAME}-base/${GAME_NAME}/cfg/server.cfg

ADD ${MAP_DIR} /${GAME_NAME}-base/${GAME_NAME}/maps

ADD ${GMOD_ADDON_DIR} /${GAME_NAME}-base/${GAME_NAME}/addons

ADD start-server.sh /"${GAME_NAME}"-base/start-server.sh

RUN chmod 777 /${GAME_NAME}-base/start-server.sh

CMD /bin/sh /${GAME_NAME}-base/start-server.sh
