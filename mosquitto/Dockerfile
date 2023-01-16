FROM eclipse-mosquitto:2 AS mosquitto
RUN apk add jq

COPY ./mosquitto-entrypoint.sh /
ENTRYPOINT ["/mosquitto-entrypoint.sh"]
