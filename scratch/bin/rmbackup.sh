#!/bin/bash

BACKUP_DIR=/opt/atlassian/data/confluencec/backups
FILE_PATTERN="*.zip"

FILE_COUNT=`ls $BACKUP_DIR | wc -l`

echo $FILE_COUNT

if [ $FILE_COUNT -gt 5 ]; then
    echo "delete file."
    find $BACKUP_DIR -type f -name $FILE_PATTERN -mtime 120 -exec ls '{}' \;
else
    echo "do nothing."
fi