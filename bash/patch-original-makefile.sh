mv Makefile bash.make
sed -i -E 's/^config.status:.+/config.status:/' bash.make
sed -i -E 's/^\t\$\(SHELL\) .\/config.status --recheck/\ttouch $@/' bash.make
sed -i -E 's/^VENDOR = .+$/VENDOR = Playbit/' bash.make
sed -i -E 's/^MACHTYPE = .+$/MACHTYPE = aarch64-playbit/' bash.make
