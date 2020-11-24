#!/bin/bash

rm -rf postgres/pgdata

# Allow "tr" to process non-utf8 byte sequences
export LC_CTYPE=C

# read random bytes and keep only alphanumerics
export TODO_SECRET=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c32)
echo TODO_SECRET=$TODO_SECRET

docker-compose up --build --force-recreate
