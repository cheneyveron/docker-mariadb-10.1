#!/bin/bash

ls -la /var/lib/mysql/backup

#Config git
git config --global user.email "${GIT_EMAIL}"
git config --global user.name "${GIT_USER}"
#Clone repository
git clone https://${GIT_USER}:${GIT_TOKEN}@${GIT_REPO} /var/lib/mysql/backup
#Pull update
cd /var/lib/mysql/backup
git pull

#Run crond
cron

exec /usr/local/bin/docker-entrypoint.sh mysqld