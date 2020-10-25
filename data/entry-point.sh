#! /bin/bash

set -m

/opt/mssql/bin/sqlservr  &

cat << EOF > setup.sql
IF (NOT EXISTS (SELECT * FROM sys.databases where [name] = '${DATABASE_NAME}'))
  CREATE DATABASE [${DATABASE_NAME}]
GO
EOF

# the max times is 10
times=0
while [ $times -le 10 ]
do
  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "${SA_PASSWORD}" -i setup.sql -t 30 -l 30

  result=$?
  if [ $result -eq '0' ]; then
    echo ""
    break
  fi

  sleep 5
  times=$((times + 1))
  echo "-------------retry times: ${times}"
done

if [ $times -eq 10 ]; then
  echo "-------------retry to ${times}, exist 1"
  exit 1
fi

fg 1
