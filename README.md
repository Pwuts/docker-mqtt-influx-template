IoT services docker stack
=========================
* **Mosquitto** - MQTT message broker
  * Listens on TCP port `1883`
  * Management UI on port `8088` [(🚀)](http://localhost:8088)

* **InfluxDB** - time-series database
  * Admin UI [(🚀)](http://localhost:8086) and [InfluxDB API v2] on port `8086`

* **Telegraf** - can forward messages/metrics from MQTT to InfluxDB,
  based on [rules][telegraf] in `telegraf/telegraf.conf`

[InfluxDB API v2]: https://docs.influxdata.com/influxdb/cloud/api-guide/
[telegraf]: https://www.influxdata.com/integration/mqtt-telegraf-consumer/

Default credentials for everything are `hoco:verysecret`.


Configuration
-------------
Credentials can be set through environment variables at setup time and are used by `docker-compose`. After initial setup, these should not be changed, as changes are *not* propagated to configuration, with the exception of `TELEGRAF_MQTT_PASSWORD`.
* `ADMIN_USERNAME`: default username to Mosquitto admin UI and InfluxDB
* `ADMIN_PASSWORD`: default password to Mosquitto admin UI and InfluxDB
* `MQTT_ADMIN_USERNAME`: Mosquitto admin API username
* `MQTT_ADMIN_PASSWORD`: Mosquitto admin API password
* `INFLUXDB_DEFAULT_ORG`: default InfluxDB organization
* `INFLUXDB_DEFAULT_BUCKET`: default InfluxDB bucket
* `TELEGRAF_MQTT_PASSWORD`: used by Telegraf to listen to MQTT traffic; `telegraf` user has rights to listen on all non-system topics
* `TELEGRAF_INFLUXDB_TOKEN`: used by Telegraf to write to InfluxDB

Default usernames are `hoco`, default passwords are `verysecret`.

The system configuration for InfluxDB can also be adjusted through environment variables; these are read every time at start-up.
* `INFLUXD_{SETTING_SLUG}`: see https://hub.docker.com/_/influxdb > Configuration


Other configuration can be set in these files:
* `dynsec_default.json`: default Mosquitto users, groups & rights.
  **Do not edit** the `{admin}` user or credentials for the `telegraf` user unless you want stuff to break.
* `telegraf/telegraf.conf`: MQTT -> InfluxDB forwarding rules etc.
* `mosquitto/mosquitto.conf`: Mosquitto system configuration

### After deployment
* Clients/users/roles for MQTT can be created and managed in the [management center](http://localhost:8088)
* InfluxDB can be configured through the [admin UI](http://localhost:8086)
* Rules for forwarding metrics from MQTT to InfluxDB can only be set in `telegraf/telegraf.conf` unfortunately


How to develop/test
-------------------
1. Clone repo
2. Make sure you have rights to use port `1883`, or change the port in `docker-compose.yml`
3. Comment/uncomment volume/bind mounts in `docker-compose.yml`
4. Run `docker-compose up`
5. Tweak the configuration


How to deploy
-------------
Generate secure passwords with your password manager or `openssl rand -base64 [length]`

### Server with `docker-compose`
1. Clone repo
2. Set environment variables and/or adjust configuration
3. Run `docker-compose up -d`

### Portainer
1. Fork repo and adjust config files
2. Stacks -> `+ Add stack` -> `Repository`
3. Configure stack with URL of your repository
4. Set environment variables (under *Environment variables*)
5. Deploy the stack
