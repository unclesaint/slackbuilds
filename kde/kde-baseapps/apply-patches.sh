
SB_PATCHDIR=${CWD}/patches

set -e -o pipefail

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/kdebase.patch 
zcat ${SB_PATCHDIR}/kdebase-4.1.80-nsplugins-paths.patch.gz | patch -p2 -E --backup --verbose
zcat ${SB_PATCHDIR}/kdebase-4.2.1-home-icon-slk.patch.gz | patch -p2 -E --backup --verbose

# fix disabling automatic spell checking in the Konqueror UI (kde#228593)
zcat ${SB_PATCHDIR}/kdebase-4.4.0-konqueror-kde\#228593.patch.gz | patch -p2 -E --backup --verbose

# Password & User account becomes non responding
patch -p2 -E --backup --verbose -i ${SB_PATCHDIR}/kdebase-4.3.4-bz\#609039-chfn-parse.patch

## upstream patches
# http://bugs.kde.org/292250, While holding Ctrl, clicking an item
# to unselect it clears the selection
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-4.8.0-kde\#292250.patch

#trunk patches

set +e +o pipefail
