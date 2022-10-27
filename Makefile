include /etc/default/telegraf

VARS:=$(shell sed -ne 's/ *\#.*$$//; /./ s/=.*$$// p' .env )
$(foreach v,$(VARS),$(eval $(shell echo export $(v)="$($(v))")))

progname = telegraf
confdir = /etc/telegraf/telegraf.d

install: $(confdir)/*.conf

restart:
	sudo systemctl restart telegraf.service

test:
	telegraf --config /etc/telegraf/telegraf.conf --config-directory $(confdir) --test

$(confdir)/%.conf: %.conf
	cp $< $@