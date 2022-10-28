ifneq (,$(wildcard /etc/default/telegraf))
    include /etc/default/telegraf
    export
endif

progname = telegraf
confdir = /etc/telegraf/telegraf.d

install: $(confdir)/*.conf

restart:
	sudo systemctl restart telegraf.service

test:
	$(shell	MQTT_USERNAME=$(MQTT_USERNAME) MQTT_PASSWORD=$(MQTT_PASSWORD) \
	INFLUXDB_USERNAME=$(MQTT_USERNAME) INFLUXDB_PASSWORD=$(MQTT_PASSWORD) \
	telegraf --config /etc/telegraf/telegraf.conf --config-directory $(confdir) --test )

$(confdir)/%.conf: %.conf
	cp $< $@