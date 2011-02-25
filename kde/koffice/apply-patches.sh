
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/koffice-2.3.1-libwpg02.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/koffice-2.3.2-gcc46.patch

set +e +o pipefail
