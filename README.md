# fi.oh2th.pi-telegraf.conf

Telegraf configuration on pi.oh2th.fi

Several sources are used in the configuration and currentlyt supported are:

- BLE beacons as explained in <https://github.com/oh2mp/esp32_ble2mqtt>
- Some of the go-eCharger V2 API Keys <https://github.com/goecharger/go-eCharger-API-v2/blob/main/apikeys-en.md>
- Owntracks - <https://owntracks.org/>
- Shelly - <https://shelly.cloud/> sensors with MQTT topics for power,energy, current, voltage
- Synology NAS by SNMP - limited to hostname, uptime and upsInfoStatus

## OS Secrets store

The OS secrets store enabled in secretstores-os.conf is used to save the password for MQTT and INFLUXDB users.

Use telegraf to set the secrets:

'''
sudo -u telegraf telegraf secrets set telegraf mqtt_username
sudo -u telegraf telegraf secrets set telegraf mqtt_password
sudo -u telegraf telegraf secrets set telegraf influxdb_username
sudo -u telegraf telegraf secrets set telegraf influxdb_password
sudo -u telegraf telegraf secrets list
'''

## BLE Beacons

## go-e Charger

## IObroker - ICO

## IObroker - VW-connect

## Owntracks

## Shelly

## Synology NAS
