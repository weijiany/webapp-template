#! /bin/bash

dotnet-fm migrate -c 'Server=webapp-sql;Database=WebApp;User Id=sa;Password=WJY@123456;' \
    -p SqlServer2016 \
    -a ./out/Migration.dll
