# fi.oh2th.pi-telegraf.conf

Telegraf configuration on pi.oh2th.fi

Several sources are used in the configuration and currently supported are:

- BLE beacons as explained in <https://github.com/oh2mp/esp32_ble2mqtt>
- Some of the go-eCharger V2 API Keys <https://github.com/goecharger/go-eCharger-API-v2/blob/main/apikeys-en.md>
- Shelly - <https://shelly.cloud/> sensors with MQTT topics for power, energy, current, voltage
- Teltonika FMB003

## OS Secrets store

The OS secrets store enabled in `secretstores-os.conf` is used to save the password for MQTT and INFLUXDB users.

Use telegraf to set the secrets:

```bash
sudo -u telegraf telegraf secrets set telegraf mqtt_username
sudo -u telegraf telegraf secrets set telegraf mqtt_password
sudo -u telegraf telegraf secrets set telegraf influxdb_username
sudo -u telegraf telegraf secrets set telegraf influxdb_password
sudo -u telegraf telegraf secrets list
```

## BLE Beacons

**File**: `inputs-mqtt-ble.conf`
Reads data from BLE beacons via MQTT topics. Used for tracking and telemetry data from BLE devices.

## go-e Charger

**File**: `inputs-mqtt-goe.conf`
Monitors go-eCharger devices using MQTT. Captures charging metrics such as power, energy, and status.

## IObroker - ICO

**File**: `inputs-mqtt-iobroker-ico.conf`
Integrates with IObroker to collect metrics related to ICO (Intelligent Control Objects) via MQTT.

## IObroker - VW-connect

**File**: `inputs-mqtt-iobroker-vw-connect.conf`
Fetches telemetry and status data from VW vehicles connected to IObroker using MQTT.

## Shelly

### Shelly EM

**File**: `inputs-mqtt-shelly-EM.conf`
Captures energy monitoring data from Shelly EM devices via MQTT.

### Shelly PM1

**File**: `inputs-mqtt-shelly-PM1.conf`
Monitors power and energy usage from Shelly PM1 devices using MQTT.

### Shelly V1

**File**: `inputs-mqtt-shelly-V1.conf`
Reads telemetry data from Shelly V1 devices via MQTT.

## Teltonika FMB

**File**: `inputs-mqtt-fmb003.conf`
Processes GPS and telemetry data from Teltonika FMB003 devices. Includes metrics such as location, speed, voltage, and battery status.
