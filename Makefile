progname = telegraf
confdir = /etc/telegraf/telegraf.d

conf_files = *.conf

install: $(confdir)/*.conf

$(confdir)/%.conf: %.conf
	echo cp $< $@

