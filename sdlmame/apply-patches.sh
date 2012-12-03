
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p0 -E -R --backup --verbose -i ${SB_PATCHDIR}/${NAME}-0.147-revert.patch

if [ "${PATCHLEVEL}" -gt 0 ] ;then
  for i in $( seq -w ${PATCHLEVEL} ) ; do
    patch -p0 -i ${SVER//.}u${i}.diff
  done
fi

[ "${SB_HS}" = "YES" ] && patch -p0 -E --backup -z .hiscore --verbose -i ${HSSRCARCHIVE}.diff

patch -p0 -E --backup -z .nogconf --verbose -i ${SB_PATCHDIR}/sdlmame-0.139.u4-nogconf.patch

set +e +o pipefail
