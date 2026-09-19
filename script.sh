#!/bin/bash

if ! [ "$USER" = "root" ]; then echo "You need to be root to run this script." 1>&2; exit 1; fi

powercap_file="/etc/udev/rules.d/99-powercap.rules"

nethogs=$(which nethogs 2>/dev/null) || echo "Nethogs not found! Please install." 1>&2
which sensors-detect 2>&1 >/dev/null || echo "sensors-detect not found! Please install lm-sensors." 1>&2

if ! [ "$1" = "--revert" ]; then
	setcap "cap_net_admin,cap_net_raw,cap_dac_read_search,cap_sys_ptrace+pe" "$nethogs"

	echo 'SUBSYSTEM=="powercap", KERNEL=="intel-rapl*", RUN+="/usr/bin/chmod a+r /sys/%p/energy_uj"' | tee "$powercap_file"
	udevadm control --reload-rules
	udevadm trigger --subsystem-match=powercap

	sensors-detect --auto
else
	setcap -r "$nethogs"

	rm -f $powercap_file
fi
