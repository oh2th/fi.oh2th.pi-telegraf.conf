progname = telegraf
confdir = /etc/telegraf/telegraf.d

install: $(confdir)/*.conf

$(confdir)/%.conf: %.conf
	cp $< $@