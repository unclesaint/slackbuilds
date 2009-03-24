#!/bin/sh

SB_PATCHDIR=${CWD}/patches

# Set to test (some patches require others, so, is not 100%)
DRYRUN=${DRYRUN:-NO}

if [ "${DRYRUN}" = "YES" ] ; then
  DRYRUN_OPT="--dry-run"
fi

if [ "${VERBOSE}" = "YES" ] ; then
  VERBOSE_OPT="--verbose"
fi

if [ "${SVERBOSE}" = "YES" ] ; then
  set -o xtrace
fi

PATCHCOM="patch ${DRYRUN_OPT} -p1 -F1 -s ${VERBOSE_OPT}"

# Adds layer 7 iptables support
#zcat ${SB_PATCHDIR}/kernel-2.6.25-layer7-2.20.patch.gz | ${PATCHCOM} || exit 1

zcat ${SB_PATCHDIR}/acpi-dsdt-initrd-v0.9c-2.6.28.patch.gz | ${PATCHCOM} || exit 1

# This patch adds a "make nonint_oldconfig" which is non-interactive and
# also gives a list of missing options at the end. Useful for automated
# builds (as used in the buildsystem).
zcat ${SB_PATCHDIR}/linux-2.6-build-nonintconfig.patch.gz | ${PATCHCOM} || exit 1

zcat ${SB_PATCHDIR}/linux-2.6-makefile-after_link.patch.gz | ${PATCHCOM} || exit 1

#
# misc small stuff to make things compile
#
C=$(zcat ${SB_PATCHDIR}/linux-2.6-compile-fixes.patch.gz | wc -l | awk '{print $1}')
if [ "$C" -gt 10 ]; then
  zcat ${SB_PATCHDIR}/linux-2.6-compile-fixes.patch.gz | ${PATCHCOM} || exit 1
fi

# revert patches from upstream that conflict or that we get via other means
C=$(zcat ${SB_PATCHDIR}/linux-2.6-upstream-reverts.patch.gz | wc -l | awk '{print $1}')
if [ "$C" -gt 10 ]; then
  zcat ${SB_PATCHDIR}/linux-2.6-upstream-reverts.patch.gz | ${PATCHCOM} -R || exit 1
fi

#zcat ${SB_PATCHDIR}/git-cpufreq.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/git-bluetooth.patch.gz | ${PATCHCOM} || exit 1

C=$(zcat ${SB_PATCHDIR}/linux-2.6-hotfixes.patch.gz | wc -l | awk '{print $1}')
if [ "$C" -gt 10 ]; then
  zcat ${SB_PATCHDIR}/linux-2.6-hotfixes.patch.gz | ${PATCHCOM} || exit 1
fi

# Roland's utrace ptrace replacement.
zcat ${SB_PATCHDIR}/linux-2.6-tracehook.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/linux-2.6-utrace.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/linux-2.6-utrace-ftrace.patch.gz | ${PATCHCOM} || exit 1

# DMA API debugging
zcat ${SB_PATCHDIR}/linux-2.6-debug-dma-api.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/dma-api-debug-fixes.patch.gz | ${PATCHCOM} || exit 1

# enable sysrq-c on all kernels, not only kexec
zcat ${SB_PATCHDIR}/linux-2.6-sysrq-c.patch.gz | ${PATCHCOM} || exit 1

# Architecture patches

#
# Exec shield
#
zcat ${SB_PATCHDIR}/linux-2.6-execshield.patch.gz | ${PATCHCOM} || exit 1

#
# bugfixes to drivers and filesystems
#

# ext4
zcat ${SB_PATCHDIR}/linux-2.6-ext4-flush-on-close.patch.gz | ${PATCHCOM} || exit 1

# xfs

# btrfs
zcat ${SB_PATCHDIR}/linux-2.6-btrfs-experimental-branch.patch.gz | ${PATCHCOM} || exit 1

# USB

# ACPI
zcat ${SB_PATCHDIR}/linux-2.6-defaults-acpi-video.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/linux-2.6-acpi-video-dos.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/linux-2.6-acpi-strict-resources.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/linux-2.6-hwmon-atk0110.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/linux-2.6-acpi-video-didl-intel-outputs.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/linux-2.6-sony-laptop-rfkill.patch.gz | ${PATCHCOM} || exit 1

# Various low-impact patches to aid debugging.
zcat ${SB_PATCHDIR}/linux-2.6-debug-sizeof-structs.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/linux-2.6-debug-nmi-timeout.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/linux-2.6-debug-taint-vm.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/linux-2.6-debug-spinlock-taint.patch.gz | ${PATCHCOM} || exit 1
# try to find out what is breaking acpi-cpufreq
zcat ${SB_PATCHDIR}/linux-2.6-debug-vm-would-have-oomkilled.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/linux-2.6-debug-always-inline-kzalloc.patch.gz | ${PATCHCOM} || exit 1

#
# PCI
#
# disable message signaled interrupts
zcat ${SB_PATCHDIR}/linux-2.6-defaults-pci_no_msi.patch.gz | ${PATCHCOM} || exit 1

# update the pciehp driver
#zcat ${SB_PATCHDIR}/linux-2.6-pciehp-update.patch.gz | ${PATCHCOM} || exit 1

# default to enabling passively listening for hotplug events
#zcat ${SB_PATCHDIR}/linux-2.6-defaults-pciehp.patch.gz | ${PATCHCOM} || exit 1

# Add /sys/bus/pci/devices/*/remove_id
zcat ${SB_PATCHDIR}/linux-2.6-pci-sysfs-remove-id.patch.gz | ${PATCHCOM} || exit 1

#
# SCSI Bits.
#
# fix cpqarray pci enable
zcat ${SB_PATCHDIR}/linux-2.6-scsi-cpqarray-set-master.patch.gz | ${PATCHCOM} || exit 1

# ALSA

# block/bio
#

# Filesystem patches.

# Networking

# Misc fixes
# The input layer spews crap no-one cares about.
zcat ${SB_PATCHDIR}/linux-2.6-input-kill-stupid-messages.patch.gz | ${PATCHCOM} || exit 1

# Get away from having to poll Toshibas
zcat ${SB_PATCHDIR}/linux-2.6-input-fix-toshiba-hotkeys.patch.gz | ${PATCHCOM} || exit 1

# HID: add support for another version of 0e8f:0003 device in hid-pl
zcat ${SB_PATCHDIR}/linux-2.6-input-hid-extra-gamepad.patch.gz | ${PATCHCOM} || exit 1

# Allow to use 480600 baud on 16C950 UARTs
zcat ${SB_PATCHDIR}/linux-2.6-serial-460800.patch.gz | ${PATCHCOM} || exit 1

zcat ${SB_PATCHDIR}/increase-MAX_LOCKDEP_ENTRIES.patch.gz | ${PATCHCOM} || exit 1

# Silence some useless messages that still get printed with 'quiet'
zcat ${SB_PATCHDIR}/linux-2.6-silence-noise.patch.gz | ${PATCHCOM} || exit 1

# Make fbcon not show the penguins with 'quiet'
zcat ${SB_PATCHDIR}/linux-2.6-silence-fbcon-logo.patch.gz | ${PATCHCOM} || exit 1

# Changes to upstream defaults.

# squelch hda_beep by default
zcat ${SB_PATCHDIR}/linux-2.6-defaults-alsa-hda-beep-off.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/hda_intel-prealloc-4mb-dmabuffer.patch.gz | ${PATCHCOM} || exit 1

# libata

#
# VM related fixes.
#

# wireless patches headed for 2.6.27
#zcat ${SB_PATCHDIR}/linux-2.6-wireless.patch.gz | ${PATCHCOM} || exit 1
# wireless patches headed for 2.6.28
#zcat ${SB_PATCHDIR}/linux-2.6-wireless-pending.patch.gz | ${PATCHCOM} || exit 1

# rt2x00: back-port activity LED init patches
zcat ${SB_PATCHDIR}/linux-2.6-rt2x00-asus-leds.patch.gz | ${PATCHCOM} || exit 1

# back-port scan result aging patches
zcat ${SB_PATCHDIR}/linux-2.6-mac80211-age-scan-results-on-resume.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/linux-2.6-ipw2x00-age-scan-results-on-resume.patch.gz | ${PATCHCOM} || exit 1

# http://www.lirc.org/
zcat ${SB_PATCHDIR}/linux-2.6-lirc.patch.gz | ${PATCHCOM} || exit 1

# Fix the return code CD accesses when the CDROM drive door is closed
# but the drive isn't yet ready.
zcat ${SB_PATCHDIR}/linux-2.6-cdrom-door-status.patch.gz | ${PATCHCOM} || exit 1

zcat ${SB_PATCHDIR}/linux-2.6-e1000-ich9.patch.gz | ${PATCHCOM} || exit 1

# implement smarter atime updates support.
zcat ${SB_PATCHDIR}/linux-2.6-smarter-relatime.patch.gz | ${PATCHCOM} || exit 1

zcat ${SB_PATCHDIR}/agp-set_memory_ucwb.patch.gz | ${PATCHCOM} || exit 1
# Nouveau DRM + drm fixes
zcat ${SB_PATCHDIR}/drm-next.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/drm-modesetting-radeon.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/drm-nouveau.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/drm-no-gem-on-i8xx.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/drm-i915-resume-force-mode.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/drm-intel-big-hammer.patch.gz | ${PATCHCOM} || exit 1

# linux1394 git patches
zcat ${SB_PATCHDIR}/linux-2.6-firewire-git-update.patch.gz | ${PATCHCOM} || exit 1
#C=$(zcat ${SB_PATCHDIR}/linux-2.6-firewire-git-pending.patch.gz | wc -l | awk '{print $1}')
#if [ "$C" -gt 10 ]; then
  #zcat ${SB_PATCHDIR}/linux-2.6-firewire-git-pending.patch.gz | ${PATCHCOM} || exit 1
#fi

# silence the ACPI blacklist code
zcat ${SB_PATCHDIR}/linux-2.6-silence-acpi-blacklist.patch.gz | ${PATCHCOM} || exit 1

# V4L/DVB updates/fixes/experimental drivers
zcat ${SB_PATCHDIR}/linux-2.6-v4l-dvb-fixes.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/linux-2.6-v4l-dvb-update.patch.gz | ${PATCHCOM} || exit 1
zcat ${SB_PATCHDIR}/linux-2.6-v4l-dvb-experimental.patch.gz | ${PATCHCOM} || exit 1

# revert 8b249b6856f16f09b0e5b79ce5f4d435e439b9d6
zcat ${SB_PATCHDIR}/revert-fix-modules_install-via-nfs.patch.gz | ${PATCHCOM} || exit 1

zcat ${SB_PATCHDIR}/cpufreq-add-atom-to-p4-clockmod.patch.gz | ${PATCHCOM} || exit 1
