FROM ubuntu:latest

RUN apt-get update -y && apt-get upgrade -y

WORKDIR /root

COPY ubuntu.sh .
