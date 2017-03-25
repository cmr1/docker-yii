#!/usr/bin/env bash

# Exit the script as soon as something fails.
set -e

/wait-for-it.sh ${DB_HOST}:${DB_PORT} --strict --timeout=60

if [[ "$APP_ENV" == "development" ]]; then
  mysql -h ${DB_HOST} -u root -p${MYSQL_ROOT_PASSWORD} -e "set @@global.sql_mode = '';"
  (\
    mysql -h ${DB_HOST} -u root -p${MYSQL_ROOT_PASSWORD} -e "create database ${DB_NAME}" \
    && mysql -h ${DB_HOST} -u root -p${MYSQL_ROOT_PASSWORD} ${DB_NAME} < /sql/${APP_ENV}.seed.sql\
  ) || echo "Using existing DB: ${DB_NAME} | Reset this by running 'docker volume rm dockeryii_mysql'"
fi

# Execute the CMD from the Dockerfile and pass in all of its arguments.
exec "$@"