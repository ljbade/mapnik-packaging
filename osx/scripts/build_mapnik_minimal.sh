set -e 
cd ${MAPNIK_SOURCE}

echo '...Updating and building mapnik minimal'

echo "PREFIX = '${MAPNIK_INSTALL}'" > config.py
echo "DESTDIR = '${MAPNIK_DESTDIR}'" >> config.py
echo "CXX = '${CXX}'" >> config.py
echo "CC = '${CC}'" >> config.py
echo "CUSTOM_CXXFLAGS = '${CXXFLAGS}'" >> config.py
echo "CUSTOM_CFLAGS = '${CFLAGS}'" >> config.py
echo "CUSTOM_LDFLAGS = '${LDFLAGS}'" >> config.py
echo "OPTIMIZATION = '${OPTIMIZATION}'" >> config.py
echo "RUNTIME_LINK = 'static'" >> config.py
echo "PATH = '${BUILD}/bin/'" >> config.py
echo "BOOST_INCLUDES = '${BUILD}/include'" >> config.py
echo "BOOST_LIBS = '${BUILD}/lib'" >> config.py
echo "FREETYPE_CONFIG = '${BUILD}/bin/freetype-config'" >> config.py
echo "ICU_INCLUDES = '${BUILD}/include'" >> config.py
echo "ICU_LIBS = '${BUILD}/lib'" >> config.py
echo "PNG_INCLUDES = '${BUILD}/include'" >> config.py
echo "PNG_LIBS = '${BUILD}/lib'" >> config.py

make uninstall
./configure \
  PATH_REMOVE="/usr/include" \
  HOST=${ARCH_NAME} \
  FULL_LIB_PATH=False \
  BINDINGS='' \
  INPUT_PLUGINS=shape,csv \
  SAMPLE_INPUT_PLUGINS=False \
  CAIRO=False \
  JPEG=False \
  TIFF=False \
  PROJ=False \
  SVG2PNG=False \
  SHAPEINDEX=False \
  CPP_TESTS=True \
  DEMO=True \
  SVG_RENDERER=False \
  PGSQL2SQLITE=False \
  SYSTEM_FONTS=/System/Library/Fonts
make
make install