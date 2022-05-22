FROM ubuntu:jammy

LABEL version="1.0"
LABEL maintainer="Guillaume Mazoyer"
LABEL description="Ubuntu 22.04 container for Ansible role testing"

ENV DEBIAN_FRONTEND noninteractive

# Install requirements
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
               build-essential libffi-dev libssl-dev locales locales-all \
               python3-pip python3-dev python3-setuptools python3-wheel \
               sudo systemd \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/share/doc && rm -rf /usr/share/man \
    && apt-get clean \
    && echo 'Europe/Paris' > /etc/timezone

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Install Ansible
RUN pip3 install cryptography ansible

# Ansible inventory file
RUN mkdir -p /etc/ansible/roles \
    && echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Make sure systemd does not mess with us
RUN rm -f /lib/systemd/system/multi-user.target.wants/getty.target

VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]
