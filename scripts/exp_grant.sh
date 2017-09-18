#!/bin/bash  
#Function export user privileges

mygrants()
{
mysql -B -N -u'root' -p${MYSQL_ROOT_PASSWORD} -e "SELECT DISTINCT CONCAT(
'SHOW GRANTS FOR ''', user, '''@''', host, ''';'
) AS query FROM mysql.user WHERE user NOT IN ('root','phpmyadmin','debian-sys-maint')"  | \
mysql -u'root' -p${MYSQL_ROOT_PASSWORD} | \
sed 's/\(GRANT .*\)/\1;/;s/^\(Grants for .*\)/## \1 ##/;/##/{x;p;x;}'
}
mygrants