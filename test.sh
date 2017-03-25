#!/bin/bash

curl -I http://127.0.0.1

curl -I http://127.0.0.1 | head -n 1 | cut -d$' ' -f2

([[ "$(curl -Is http://127.0.0.1 | head -n 1|cut -d$' ' -f2)" == "200" ]] && echo "Success!") || echo "Failed!"