#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#

FROM mariadb:10.1

MAINTAINER Cheney Veron <cheneyveron@live.cn>

ADD scripts/exp_grant.sh /usr/bin/exp_grant.sh
RUN chmod +x /usr/bin/exp_grant.sh

#Cron
RUN apt-get update \
    && apt-get install -y --no-install-recommends cron git \
	&& rm -rf /var/lib/apt/lists/*

ADD scripts/backup_db.sh /usr/bin/backup_db.sh
RUN chmod +x /usr/bin/backup_db.sh \
    && echo "0 0 * * * root bash /usr/bin/backup_db.sh > /dev/null 2>&1" >> /etc/cron.d/root \
	&& echo "20 0 * * * root apt-get update -y > /dev/null 2>&1" >> /etc/cron.d/root \
	&& echo "# Empty Line" >> /etc/cron.d/root \
    chmod 0644 /etc/cron.d/root \
ADD scripts/start.sh /usr/bin/start.sh
RUN chmod +x /usr/bin/start.sh

ENTRYPOINT ["start.sh"]