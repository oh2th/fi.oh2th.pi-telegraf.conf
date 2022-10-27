progname = telegraf
confdir = /etc/telegraf/telegraf.d

install: $(confdir)/*.conf

restart:
	sudo systemctl restart telegraf.service

$(confdir)/%.conf: %.conf
	cp $< $@