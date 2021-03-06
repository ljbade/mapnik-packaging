#!/usr/bin/env bash
set -e -u
set -o pipefail
mkdir -p ${PACKAGES}
cd ${PACKAGES}

download bzip2-${BZIP2_VERSION}.tar.gz

echoerr '*building bzip2'
rm -rf bzip2-${BZIP2_VERSION}
tar xf bzip2-${BZIP2_VERSION}.tar.gz
cd bzip2-${BZIP2_VERSION}
if [ "${RANLIB:-false}" != false ]; then
  RANLIB_ARGS="RANLIB=${RANLIB}"
else
  RANLIB_ARGS=""
fi
# note: -i -k only for android since ranlib breaks: error: bz2: no archive symbol table (run ranlib)
$MAKE install PREFIX=${BUILD} CC="$CC" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS" ${RANLIB_ARGS} -i -k
if [ ${PLATFORM} = 'Android' ]; then
    ${RANLIB} ${BUILD}/lib/libbz2.a
fi
cd ${PACKAGES}
