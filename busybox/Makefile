include ../playbit.defs.mk
#
# run with 'make NO_CLEANUP=1' to leave build directory at BUSYBOX_BUILD intact
#

BUSYBOX_VERSION := 1.36.1
BUSYBOX_BUILD := $(BUILD_DIR)/busybox-$(BUSYBOX_VERSION)_$(ARCH)
DESTDIR := $(DISTROOT)-$(ARCH)
PROGS := $(shell grep -vE '^\s*#|^\s*$$' progs.txt)
DESTDIR_PROGS := $(addprefix $(DESTDIR),$(PROGS))
SRCS := $(wildcard */*.c) $(wildcard */*.h)

all: $(DESTDIR_PROGS)

clean:
	$(Q)rm -rf "$(BUSYBOX_BUILD)" $(DESTDIR_PROGS)

upgrade:
	$(Q)bash upgrade-busybox.sh

check-progs: $(BUSYBOX_BUILD)/busybox
	$(Q)grep -vE '^\s*#|^\s*$$' progs.txt | sed -E 's/^.+\///' | sort -u > /tmp/busybox-ls1
	$(Q)"$(BUSYBOX_BUILD)/busybox" --list | sort -u > /tmp/busybox-ls2
	$(Q)diff -u /tmp/busybox-ls1 /tmp/busybox-ls2 || \
	    (echo "progs.txt differs from '$(BUSYBOX_BUILD)/busybox --list'"; exit 1)

$(DESTDIR)/sbin/busybox: $(BUSYBOX_BUILD)/busybox
	@echo "COPY $< -> $@"
	$(Q)mkdir -p "$(@D)"
	$(Q)install -m0755 "$<" "$@"

$(DESTDIR)/sbin/%: $(DESTDIR)/sbin/busybox
	@echo "LINK $@"
	$(Q)ln -f "$<" "$@"

$(DESTDIR)/bin/%: $(DESTDIR)/sbin/busybox
	@echo "LINK $@"
	$(Q)ln -f "$<" "$@"

$(BUSYBOX_BUILD)/busybox: $(BUSYBOX_BUILD)/.config
	@echo "MAKE -C $(BUSYBOX_BUILD)"
	$(Q)PATH=$(BUSYBOX_BUILD)/xbin:$(PATH) \
	$(MAKE) -C $(BUSYBOX_BUILD) \
		ARCH=$(ARCH) \
		AS=clang \
		CC=clang \
		LD=ld \
		HOSTCC=clang \
		HOSTCXX=clang++ \
		HOSTCFLAGS="-static -w" \
		HOSTCXXFLAGS="-static -w" \
		HOSTLDFLAGS="-static" \
		CC=clang \
		CXX=clang++ \
		CFLAGS="--target=$(ARCH)-playbit -static -w" \
		CXXFLAGS="--target=$(ARCH)-playbit -static -w" \
		LDFLAGS="-static" \
		$(if $(filter 1,$(V)),V=1,)
	$(Q)touch "$@"

$(BUSYBOX_BUILD)/.config: busybox.conf $(BUSYBOX_BUILD)/Makefile $(BUSYBOX_BUILD)/xbin/gcc $(BUSYBOX_BUILD)/xbin/ld
	@echo "COPY $< -> $@"
	$(Q)cp $< $@
	$(Q)sed -i -E -e 's@^CONFIG_EXTRA_CFLAGS="@CONFIG_EXTRA_CFLAGS="'"--target=$(ARCH)-playbit "'@' $@
	$(Q)sed -i -E -e 's@^CONFIG_EXTRA_LDFLAGS="@CONFIG_EXTRA_LDFLAGS="'"--target=$(ARCH)-playbit "'@' $@
	$(Q)sed -i -E -e 's@^CONFIG_SYSROOT=.+@CONFIG_SYSROOT="'"$(DESTDIR)"'"@' $@

# busybox really wants to build with gcc, so we "trick" it by putting "gcc" on PATH

$(BUSYBOX_BUILD)/xbin/gcc: $(BUSYBOX_BUILD)/Makefile
	@echo "GEN $@"
	$(Q)mkdir -p $(@D)
	$(Q)echo "#!/bin/sh" > $@
	$(Q)echo "exec $(TOOLCHAIN)/bin/clang \"$$""@\" -w -static" >> $@
	$(Q)chmod +x $@

$(BUSYBOX_BUILD)/xbin/ld: $(BUSYBOX_BUILD)/Makefile
	@echo "GEN $@"
	$(Q)mkdir -p $(@D)
	$(Q)echo "#!/bin/sh" > $@
	$(Q)echo "exec $(TOOLCHAIN)/bin/ld.lld --static \"$$""@\"" >> $@
	$(Q)chmod +x $@

$(BUSYBOX_BUILD)/Makefile: busybox.mk $(SRCS)
	@echo "COPY $(CURDIR) -> $(@D)"
	$(Q)rm -rf "$(@D)"
	$(Q)mkdir -p "$(@D)"
	$(Q)cp -RT . "$(@D)"
	$(Q)mv "$(@D)/busybox.mk" "$@"
	$(Q)touch $@

.PHONY: all clean upgrade check-progs
