#!/bin/bash

backup_date=$(date +%Y-%m-%d-%H-%M)

mkdir -p "./backups"

# 6. Create a backup archive
tar -czvf "./backups/${backup_date}.tar.gz" -C "volumes" . -C .. ".env"