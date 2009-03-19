
SB_PATCHDIR=${CWD}/patches

# Disable automount
zcat ${SB_PATCHDIR}/${NAME}-2.24.0-noautomount.patch.gz | patch -p0 -E --backup --verbose || exit 1
# Some changes to default config
zcat ${SB_PATCHDIR}/${NAME}-2.5.7-rhconfig.patch.gz | patch -p1 -E --backup --verbose || exit 1
zcat ${SB_PATCHDIR}/background-no-delay.patch.gz | patch -p1 -E --backup --verbose || exit 1
# Why is this not upstream ?
zcat ${SB_PATCHDIR}/${NAME}-2.23.5-dynamic-search.patch.gz | patch -p1 -E --backup --verbose || exit 1
zcat ${SB_PATCHDIR}/rtl-fix.patch.gz | patch -p1 -E --backup --verbose || exit 1

zcat ${SB_PATCHDIR}/${NAME}-gvfs-desktop-key-2.patch.gz | patch -p1 -E --backup --verbose || exit 1

# http://bugzilla.gnome.org/show_bug.cgi?id=171655
zcat ${SB_PATCHDIR}/${NAME}-2.22.0-treeview-xds-dnd-2.patch.gz | patch -p1 -E --backup --verbose || exit 1

# http://bugzilla.gnome.org/show_bug.cgi?id=519743
zcat ${SB_PATCHDIR}/${NAME}-filetype-symlink-fix.patch.gz | patch -p0 -E --backup --verbose || exit 1
