FROM ubuntu:latest

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y sudo apt-utils dialog vim zsh curl wget git sl trash-cli ruby-full build-essential fontconfig passwd

RUN apt-get update -y && apt-get upgrade -y

WORKDIR /root

COPY install.sh ./
