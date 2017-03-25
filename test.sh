#!/bin/bash

./wait-for-it.sh 127.0.0.1:80 --strict --timeout=60

[[ "$(curl -Is http://127.0.0.1 | head -n 1|cut -d$' ' -f2)" == "200" ]]