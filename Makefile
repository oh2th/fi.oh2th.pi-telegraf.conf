include /etc/default/telegraf
$(eval export $(shell sed -ne 's/ *#.*$$//; /./ s/=.*$$// p' .env))

progname = telegraf
confdir = /etc/telegraf/telegraf.d

install: $(confdir)/*.conf

restart:
	sudo systemctl restart telegraf.service

test:
	env
	telegraf -config /etc/telegraf/telegraf.conf --config-directory $(confdir) --test

$(confdir)/%.conf: %.conf
	cp $< $@