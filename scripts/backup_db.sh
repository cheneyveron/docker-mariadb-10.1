#!/bin/bash
# today
NOW=$(date +"%Y%m%d")
# delete file
DELETE=$(date +%Y%m%d --date="4 days ago")
# expire file: delete in git history
EXPIRE=$(date +%Y%m%d --date="60 days ago")

cd /var/lib/mysql/backup

# clean expire
git filter-branch --force --index-filter \
'git rm --cached --ignore-unmatch '$EXPIRE'.sql' \
--prune-empty --tag-name-filter cat -- --all
# clean delete
git rm $DELETE.sql
# clean expire
git filter-branch --force --index-filter \
'git rm --cached --ignore-unmatch grant'$EXPIRE'.sql' \
--prune-empty --tag-name-filter cat -- --all
# clean delete
git rm grant$DELETE.sql

# new backup
mysql -uroot -p${MYSQL_ROOT_PASSWORD} --lock-tables --all-databases > $NOW.sql
exp_grant.sh > grant${NOW}.sql

# upload new backup
git add -A
git commit -m "backup "$NOW
git push -u origin master