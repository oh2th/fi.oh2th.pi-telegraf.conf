ifneq (,$(wildcard /etc/default/telegraf))
    include /etc/default/telegraf
    export
endif

progname = telegraf
confdir = /etc/telegraf/telegraf.d
testdir = t

install: $(confdir)/*.conf /etc/default/telegraf

restart:
	sudo systemctl restart telegraf.service

$(testdir)/%.conf: %.conf
	[ -d $(testdir) ] || mkdir -p $(testdir)
	cp $< $@
	MQTT_USERNAME=$(MQTT_USERNAME) MQTT_PASSWORD=$(MQTT_PASSWORD) \
	INFLUXDB_USERNAME=$(MQTT_USERNAME) INFLUXDB_PASSWORD=$(MQTT_PASSWORD) \
	telegraf --config /etc/telegraf/telegraf.conf --config $@ --test --quiet

test-all:
	MQTT_USERNAME=$(MQTT_USERNAME) MQTT_PASSWORD=$(MQTT_PASSWORD) \
	INFLUXDB_USERNAME=$(MQTT_USERNAME) INFLUXDB_PASSWORD=$(MQTT_PASSWORD) \
	telegraf --config /etc/telegraf/telegraf.conf --config-directory . --test --quiet

$(confdir)/%.conf: %.conf
	sudo cp $< $@

/etc/default/telegraf: default/telegraf
	if [ -f $@ ]; then \
		@echo "\nCheck $@ for correct MQTT and INFLUXDB usernames and passwords."; \
	else; \
		@echo sudo cp -n $< $@; \
		@echo "Template copied for $@.\nEdit $@ for MQTT and INFLUXDB usernames and passwords."; \
	fi
