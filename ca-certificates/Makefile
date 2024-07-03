include ../playbit.defs.mk
NSS_VERSION := NSS_3_99_RTM
PERL ?= perl
DESTDIR := $(DISTROOT)-$(ARCH)
DEST_CERT_PEM_FILE := $(DESTDIR)/etc/ssl/cert.pem

all: $(DEST_CERT_PEM_FILE)

$(DEST_CERT_PEM_FILE): cert.pem
	$(QLOG) INSTALL $@
	$(Q)install -D -m0644 $< "$@"

uninstall: clean
clean:
	$(Q)rm -f $(DEST_CERT_PEM_FILE)
	$(Q)[ ! -d $(DESTDIR)/etc/ssl ] || find $(DESTDIR)/etc/ssl -type d -empty -delete

update:
	download -o certdata.txt \
		https://hg.mozilla.org/projects/nss/raw-file/$(NSS_VERSION)/lib/ckfw/builtins/certdata.txt
	${PERL} mk-ca-bundle.pl -n -w 64 cert.pem

.PHONY: all clean uninstall
