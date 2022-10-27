progname = telegraf
confdir = /etc/telegraf/telegraf.d

install: $(confdir)/*.conf

restart:
	sudo systemctl restart telegraf.service

test:
	env $(cat default/telegraf| xargs) telegraf -config /etc/telegraf/telegraf.conf --config-directory $(confdir) --test

$(confdir)/%.conf: %.conf
	cp $< $@