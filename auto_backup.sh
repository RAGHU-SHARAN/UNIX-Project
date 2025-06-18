#!/bin/bash

#---Configuration---
SOURCE_DIR="./Documents"
BACKUP_DIR="`pwd`/Backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
DAYS_TO_KEEP=5
LOG_FILE="${BACKUP_DIR}/backup_log.txt"
BACKUP_FILENAME="backup_${TIMESTAMP}.tar.gz"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_FILENAME}"

#---Create Backup directory if not exists---
mkdir -p "${BACKUP_DIR}"

#---Backup logic---
echo "[$(date)] Starting backup of ${SOURCE_DIR}" >> "${LOG_FILE}"
tar -czvf "${BACKUP_PATH}" "${SOURCE_DIR}" & 

if [ $? -eq 0 ];then
	echo "[$(date)] Backup successfull: ${BACKUP_FILENAME}" >>  "${LOG_FILE}"
else
	echo "[$(date)] Backup FAILED " >> "${LOG_FILE}"
	exit 1
fi

#---Delete Old Backups---
backup_counts=`find "${BACKUP_DIR}" -name "backup_*.tar.gz" -mtime ${DAYS_TO_KEEP} |wc -l`
if [ "${backup_counts}" -gt 5 ];then

        find "${BACKUP_DIR}" -name "backup_*.tar.gz" -mtime ${DAYS_TO_KEEP} -exec rm -f {} \;
        echo "[$(date)] Deleted backups older than ${DAYS_TO_KEEP} days." >> "${LOG_FILE}"
else
	echo "last 5 days backup present at ${BACKUP_DIR} "
fi

echo "[$(date) Backup completed." >> "${LOG_FILE}"
echo "Backup done : ${BACKUP_FILENAME}"
