
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
zcat ${SB_PATCHDIR}/kdebase-runtime-4.1.x-searchproviders-shortcuts.patch.gz | patch -p1 -E --backup --verbose
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/kdebase-runtime-4.6.90-iconthemes-inherit.patch
zcat ${SB_PATCHDIR}/kdebase-runtime-4.3.1-manpath.patch.gz | patch -p1 -E --backup --verbose
# add OnlyShowIn=KDE  to Desktop/Home.desktop (like trash.desktop)
zcat ${SB_PATCHDIR}/kdebase-runtime-4.3.3-home_onlyshowin_kde.patch.gz | patch -p1 -E --backup --verbose

# Launch compiz via compiz-manager so we get window decorations and
# other such decadent luxuries (AdamW 2011/01)
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/kdebase-runtime-4.5.95-compiz.patch
# tirpc support
#patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/kdebase-runtime-4.6.4-tirpc.patch

# Mandriva
zcat ${SB_PATCHDIR}/kdebase-runtime-4.3.2-knotify-fix-cpu-charge.patch.gz | patch -p1 -E --backup --verbose

# Branch patches
# https://projects.kde.org/projects/kde/kde-runtime/repository/revisions/b50bbd77572a2e20709fbb40274aface8314b4eb
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}-4.7.2-empty-jobs.patch

# Trunk  patches

## Branch upstream patches

set +e +o pipefail