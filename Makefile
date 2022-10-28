ifneq (,$(wildcard /etc/default/telegraf))
    include /etc/default/telegraf
    export
endif

progname = telegraf
confdir = /etc/telegraf/telegraf.d
testdir = /etc/telegraf/telegraf.d

install: $(confdir)/*.conf

restart:
	sudo systemctl restart telegraf.service

test-%.conf: *.conf
	MQTT_USERNAME=$(MQTT_USERNAME) MQTT_PASSWORD=$(MQTT_PASSWORD) \
	INFLUXDB_USERNAME=$(MQTT_USERNAME) INFLUXDB_PASSWORD=$(MQTT_PASSWORD) \
	telegraf --config /etc/telegraf/telegraf.conf --config $< --test --quiet

test-all:
	MQTT_USERNAME=$(MQTT_USERNAME) MQTT_PASSWORD=$(MQTT_PASSWORD) \
	INFLUXDB_USERNAME=$(MQTT_USERNAME) INFLUXDB_PASSWORD=$(MQTT_PASSWORD) \
	telegraf --config /etc/telegraf/telegraf.conf --config-directory . --test --quiet

$(confdir)/%.conf: %.conf
	sudo cp $< $@

$(testdir)/%.conf: %.conf
	[ -d $(testdir) ] || mkdir -p $(testdir)
	cp $< $@
