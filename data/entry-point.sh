#! /bin/bash

set -m

/opt/mssql/bin/sqlservr  &

cat << EOF > setup.sql
IF (NOT EXISTS (SELECT * FROM sys.databases where [name] = '${DATABASE_NAME}'))
  CREATE DATABASE [${DATABASE_NAME}]
GO
EOF

/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "${SA_PASSWORD}" -i setup.sql -t 30 -l 30

fg 1
