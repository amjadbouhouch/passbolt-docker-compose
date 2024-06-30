#!/bin/bash

# Absolute paths for files and directories
BACKUP_DIR="/scripts/backup"
BACKUP_FILE="${BACKUP_DIR}/backup.sql"
PRIVATE_KEY="${BACKUP_DIR}/serverkey_private.asc"
PUBLIC_KEY="${BACKUP_DIR}/serverkey.asc"
AVATARS_TAR="${BACKUP_DIR}/passbolt-avatars.tar.gz"
BACKUP_ARCHIVE="/scripts/backups" # Updated to an absolute path

# Ensure backup directory exists
mkdir -p "${BACKUP_DIR}"
mkdir -p "${BACKUP_ARCHIVE}" # Use -p to avoid errors if the directory already exists

# 1. Backup the database
docker exec -i passbolt-db bash -c \
'mysqldump -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE}' \
> "${BACKUP_FILE}"

# 2. Backup server public and private keys
docker cp passbolt:/etc/passbolt/gpg/serverkey_private.asc "${PRIVATE_KEY}"
docker cp passbolt:/etc/passbolt/gpg/serverkey.asc "${PUBLIC_KEY}"

# 3. Backup the application configuration (.env file)
cp /scripts/.env "${BACKUP_DIR}/.env"

# 4. Backup the avatars
docker exec -i passbolt \
    tar cvfzp - -C /usr/share/php/passbolt/ webroot/img/avatar \
    > "${AVATARS_TAR}"

# 5. Create a timestamp for the backup
backup_date=$(date +%Y-%m-%d-%H-%M)

# 6. Create a backup archive
tar -czvf "${BACKUP_ARCHIVE}/backup_${backup_date}.tar.gz" -C "${BACKUP_DIR}" . # Include "." to archive contents

# Clean up temporary backup files
rm "${BACKUP_FILE}" "${PRIVATE_KEY}" "${PUBLIC_KEY}" "${AVATARS_TAR}"
