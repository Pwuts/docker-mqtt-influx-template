#!/bin/sh
set -ex

influx user create \
    # --token $TELEGRAF_TOKEN \
    --name telegraf
