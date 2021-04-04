#!/bin/bash

FILE=$1
if [ -z $FILE ]; then
  echo "Specify the file as the first argument"
  exit 0
fi

TABLES=$(eval "sqlite3 -header -csv $FILE \".tables\"" | tr ' ' ';')
TABLES=$(printf "%s" "$TABLES" | sed 's/;;//g')

eval "mkdir -p out"

i=$((1))
while [ ! -z $(printf "%s" "$TABLES" | cut -d ';' -f $i) ]; do
  ACTTABLE=$(printf "%s" "$TABLES" | cut -d ';' -f $i)
  sqlite3 -header -csv $FILE "select * from $ACTTABLE;" > out/"$ACTTABLE".csv
  i=$(($i + 1))
done

echo "Done!"
