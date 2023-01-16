#!/bin/sh
set -e

# create config for dynamic security plugin if not exist
if [ ! -f /mosquitto/data/dynsec.json ]; then
    # copy default config
    cp /config/dynsec_default.json /mosquitto/data/dynsec.json

    # generate barebone dynsec.json with configured credentials
    mosquitto_ctrl dynsec init /tmp/dynsec.json $ADMIN_USERNAME $ADMIN_PASSWORD > /dev/null

    # merge credentials into default config
    CRED=$(jq '.clients[0] | {username, password, salt}' /tmp/dynsec.json) && \
    jq ".clients |= map(
            select(.username == \"{admin}\")
            |= (
                .username = ($CRED).username
                | .password = ($CRED).password
                | .salt = ($CRED).salt
            )
        )" /mosquitto/data/dynsec.json \
        > /tmp/dynsec.json && cp -f /tmp/dynsec.json /mosquitto/data/dynsec.json

    rm /tmp/dynsec.json
fi

# make sure telegraf credentials are up to date
mosquitto_ctrl dynsec init /tmp/dynsec.json telegraf $TELEGRAF_PASSWORD > /dev/null
CRED=$(jq '.clients[0] | {username, password, salt}' /tmp/dynsec.json) && \
jq ".clients |= map(
        select(.username == \"telegraf\")
        |= (.password = ($CRED).password | .salt = ($CRED).salt)
    )" \
    /mosquitto/data/dynsec.json \
    > /tmp/dynsec.json && cp -f /tmp/dynsec.json /mosquitto/data/dynsec.json
rm /tmp/dynsec.json
unset CRED

# start mosquitto through standard entrypoint
/docker-entrypoint.sh /usr/sbin/mosquitto -c /mosquitto/config/mosquitto.conf
