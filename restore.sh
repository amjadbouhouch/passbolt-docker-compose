#!/bin/bash
BACK_UP_SQL=./backup_2024-06-30-09-28/backup.sql

docker cp "${BACK_UP_SQL}" passbolt-db:/home/backup.sql

# 1. Backup the database
docker exec -i passbolt-db bash -c \
'mariadb -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${DATASOURCES_DEFAULT_DATABASE} < /home/backup.sql'