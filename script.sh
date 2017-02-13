#!this script to backup remote mysql database every hour
#!/bin/bash
echo "Starting..."
ROOTDIR="/backup/mysql"
YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`
HOUR=`date +%H`
SERVER="mysql.local"
BLACKLIST="information_schema performance_schema"
if [ ! -d "$ROOTDIR/$YEAR/$MONTH/$DAY/$HOUR" ]; then
    mkdir -p "$ROOTDIR/$YEAR/$MONTH/$DAY/$HOUR"
fi
echo "running dump"
dblist=`mysql -u backuper -pXXXXXXXXXXX -h $SERVER -e "show databases" | sed -n '2,$ p'`
for db in $dblist; do
    echo "Backuping $db"
    isBl=`echo $BLACKLIST |grep $db`
    if [ $? == 1 ]; then
        mysqldump --single-transaction -u backuper -pXXXXXXXXXX -h $SERVER $db | gzip --best > "$ROOTDIR/$YEAR/$MONTH/$DAY/$HOUR/$db.sql.gz"
        echo "Backup $db ends with return code $?"
    else
        echo "Database $db is on blacklist, skip"
    fi
done

echo "dump completed"