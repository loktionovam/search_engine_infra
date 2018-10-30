#!/bin/sh

DOCKERFILE=$1

awk -F = '{if ( $1=="LABEL version" ) { gsub(/"/, "", $2); print $2 }}' "${DOCKERFILE}"
