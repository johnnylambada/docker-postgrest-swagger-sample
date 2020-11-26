#!/bin/bash

rm -rf postgres/pgdata

#export TODO_SECRET=$(LC_CTYPE=C < /dev/urandom tr -dc ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 | head -c32)
export TODO_SECRET="secretSECRETsecretSECRETsecretSECRET"
echo TODO_SECRET=$TODO_SECRET

docker-compose up --build --force-recreate