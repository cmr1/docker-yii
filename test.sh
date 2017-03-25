#!/bin/bash

[[ "$(curl -Is http://localhost | head -n 1|cut -d$' ' -f2)" == "200" ]]