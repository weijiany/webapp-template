#! /bin/bash

dotnet-fm migrate -c "Server=${DATABASE_SERVER};Database=${DATABASE_NAME};User Id=sa;Password=${SA_PASSWORD};" \
    -p SqlServer2016 \
    -a ./out/Migration.dll
