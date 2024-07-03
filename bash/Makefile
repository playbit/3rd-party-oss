#!DEPENDS libc libncurses
include ../playbit.defs.mk
VERSION := 5.2.26

PRODUCTS := \
	bin/bash \
	usr/share/man/man1/bash.1.gz \

CFLAGS_FOR_HOST_AND_TARGET := \
	-Wno-deprecated-non-prototype \
	-Wno-incompatible-pointer-types-discards-qualifiers \
	-Wno-parentheses \
	-Wno-pointer-to-int-cast \

CPPFLAGS_FOR_HOST := --target=$(HOST_ARCH)-playbit $(CFLAGS_FOR_HOST_AND_TARGET)
CFLAGS_FOR_HOST := --target=$(HOST_ARCH)-playbit $(CFLAGS_FOR_HOST_AND_TARGET)
LDFLAGS_FOR_HOST := --target=$(HOST_ARCH)-playbit

PRODUCTS := $(addprefix $(DESTDIR)/,$(PRODUCTS))

all: $(PRODUCTS)
install: $(PRODUCTS)
uninstall:
	rm -rf $(PRODUCTS)
clean:
	rm -rf $(BUILDDIR) $(PRODUCTS)

$(DESTDIR)/bin/bash: Makefile
	$(MAKE) $(BUILDDIR)/bash
	$(QLOG) INSTALL $@
	$(Q)install -D -m0755 $(BUILDDIR)/bash $@
	$(Q)strip $@

$(BUILDDIR)/bash:
	$(QLOG) "MAKE -C $(BUILDDIR)"
	$(Q)rm -rf $(BUILDDIR)
	$(Q)mkdir -p $(BUILDDIR)
	$(Q)cp -R . $(BUILDDIR)
	$(Q)cp -R $(BUILDDIR)/config.h $(BUILDDIR)/config.h.in
	$(Q)mv $(BUILDDIR)/bash.make $(BUILDDIR)/Makefile
	$(Q)cp $(BUILDDIR)/Makefile $(BUILDDIR)/Makefile.in
	$(Q)sed -i -E 's/^MACHTYPE = .+$$/MACHTYPE = $(ARCH)-playbit/' $(BUILDDIR)/Makefile
	$(Q)sed -i -E 's/^Machine = .+$$/Machine = $(ARCH)/' $(BUILDDIR)/Makefile
	$(Q)sed -i -E 's/^(BASE_LDFLAGS = .+)aarch64(.+)/\1$(ARCH)\2/' $(BUILDDIR)/Makefile
	$(Q)sed -i -E 's/^(LDFLAGS_FOR_BUILD = )/\1$$(HOST_LDFLAGS1) /' $(BUILDDIR)/Makefile
	$(Q)sed -i -E 's/^(LDFLAGS_FOR_BUILD = .+)$$/\1 $$(HOST_LDFLAGS2)/' $(BUILDDIR)/Makefile
	$(Q)touch $(BUILDDIR)/stamp-h
	$(Q)touch $(BUILDDIR)/config.status
	$(Q)touch $(BUILDDIR)/pathnames.h.in
	$(Q)touch $(BUILDDIR)/pathnames.h
	$(Q)touch $(BUILDDIR)/config.h.in
	$(Q)touch $(BUILDDIR)/config.h
	$(Q)touch $(BUILDDIR)/parse.y
	$(Q)touch $(BUILDDIR)/y.tab.c
	$(Q)$(MAKE) -C "$(BUILDDIR)" \
		"BUILD_DIR=$(BUILDDIR)" \
		"top_builddir=$(BUILDDIR)" \
		"CC=$(TOOLCHAIN)/bin/$(CC)" \
		"CFLAGS=$(CFLAGS) $(CFLAGS_FOR_HOST_AND_TARGET)" \
		"CPPFLAGS=" \
		"CFLAGS_FOR_BUILD=$(CFLAGS_FOR_HOST)" \
		"CPPFLAGS_FOR_BUILD=$(CPPFLAGS_FOR_HOST)" \
		"ADDON_LDFLAGS=$(LDFLAGS)" \
		"HOST_LDFLAGS1=-L/build/distroot-$(HOST_ARCH)/lib" \
		"HOST_LDFLAGS2=$(LDFLAGS_FOR_HOST)" \
		$(if $(filter 1,$(V)),,>$(BUILDDIR)/make.out)

include ../playbit.rules.mk
.PHONY: all clean install uninstall
