#!/bin/bash
set -e -u

mkdir -p ${PACKAGES}
cd ${PACKAGES}

echo '*building libsxxl*'
rm -rf stxxl-${STXXL_VERSION}-${ARCH_NAME}
tar xf stxxl-${STXXL_VERSION}.tar.gz
mv stxxl-${STXXL_VERSION} stxxl-${STXXL_VERSION}-${ARCH_NAME}
cd stxxl-${STXXL_VERSION}-${ARCH_NAME}
export OLD_LDFLAGS=${LDFLAGS}
export LDFLAGS="${STDLIB_LDFLAGS} ${LDFLAGS}"
mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=${BUILD} \
  -DBoost_NO_SYSTEM_PATHS=ON \
  -DCMAKE_INCLUDE_PATH=${BUILD}/include \
  -DCMAKE_LIBRARY_PATH=${BUILD}/lib \
  -DBUILD_STATIC_LIBS=ON \
  -DCMAKE_BUILD_TYPE=Release
make -j${JOBS} VERBOSE=1
make install
export LDFLAGS=${OLD_LDFLAGS}
cd ${PACKAGES}

#check_and_clear_libs