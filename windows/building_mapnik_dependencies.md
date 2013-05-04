# Building Mapnik dependencies on Windows

*(Visual Studio Express 2012 64-bit)*

Buiding dependencies on windows can be _very_ tedious. The goal here is to provide
concise instructions for building individual packages using  VS express 2012 ansd latest MSVC++ compiler.

Hopefully, this will allow fully automated builds in the future.

## Prerequisites

* Visual Studio 2012 Express
  * http://www.microsoft.com/visualstudio/eng/downloads#d-2012-express
* Microsoft Visual Compiler (CTP November 2012)
  * http://www.microsoft.com/en-us/download/details.aspx?id=35515
* GNU Unix tools (GnuWin32)
  * [bsdtar](http://gnuwin32.sourceforge.net/packages/libarchive.htm)
  * [wget](http://downloads.sourceforge.net/gnuwin32/wget-1.11.4-1-setup.exe)
* [msysgit](http://msysgit.googlecode.com/files/Git-1.7.7.1-preview20111027.exe) - install into c:/Git to avoid issues with spaces in paths
* unzip (from [msysgit](http://code.google.com/p/msysgit/))
* patch (from [msysgit](http://code.google.com/p/msysgit/))
* sed (from [msysgit](http://code.google.com/p/msysgit/))
* curl (from [msysgit](http://code.google.com/p/msysgit/))
* MSys (TODO)


## Environment

We'll be using combination of "Visual Studio 2012 Command Prompt" with latest MSVC++ compiler  and  GNU tools.
Please, ensure PATH is setup correctly and GNU tools can be accessed from VC++ command prompt.
The order in %PATH% variable is important.

	set PATH=%PATH%;c:\msysgit\msysgit\bin;c:\GnuWin32\bin
	set ROOTDIR=c:\mapnik_build
	cd %ROOTDIR%
	mkdir packages
	set PKGDIR=%ROOTDIR%/packages

Here is a  *.bat file that can be run from "Developer Command Prompt for VS2012" to streamline the process :

     c:\mapnik_build>more mapnik_build.bat
     call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\bin\x86_amd64\vcvarsx86_amd64.bat"
     set PATH=C:\Program Files (x86)\Microsoft Visual C++ Compiler Nov 2012 CTP\bin\x86_amd64;%PATH%;c:\Program Files (x86)\Git\bin;c:\Program Files (x86)\GnuWin32\bin
     set ROOTDIR=C:\mapnik_build
     set PKGDIR=%ROOTDIR%/packages

     set ICU_VERSION=5.1
     set BOOST_VERSION=53
     set ZLIB_VERSION=1.2.7
     set LIBPNG_VERSION=1.6.2
     set JPEG_VERSION=9
     set FREETYPE_VERSION=2.4.11
     set POSTGRESQL_VERSION=9.2.4
     set TIFF_VERSION=4.0.3
     set WEBP_VERSION=0.3.0
     set PROJ_VERSION=4.8.0
     set PROJ_GRIDS_VERSION=1.5
     set GDAL_VERSION=1.9.2
     set LIBXML2_VERSION=2.9.1
     set PIXMAN_VERSION=0.28.2
     set CAIRO_VERSION=1.12.14
     set SQLITE_VERSION=3071602
     set EXPAT_VERSION=2.1.0
     set GEOS_VERSION=3.3.8

### Packages versions:
    see above

## Download

	cd %PKGDIR%
	curl http://iweb.dl.sourceforge.net/project/boost/boost/1.%BOOST_VERSION%.0/boost_1_%BOOST_VERSION%_0.tar.gz -O
	curl http://www.ijg.org/files/jpegsr%JPEG_VERSION%.zip -O
	curl http://ftp.igh.cnrs.fr/pub/nongnu/freetype/freetype-%FREETYPE_VERSION%.tar.gz -O
	curl http://ftp.postgresql.org/pub/source/v%POSTGRESQL_VERSION%/postgresql-%POSTGRESQL_VERSION%.tar.gz -O
	curl ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-%LIBPNG_VERSION%.tar.gz -O
	curl http://www.zlib.net/zlib-%ZLIB_VERSION%.tar.gz -O
	curl http://download.osgeo.org/libtiff/tiff-%TIFF_VERSION%.tar.gz -O
	curl https://webp.googlecode.com/files/libwebp-%WEBP_VERSION%.tar.gz
	curl http://www.cairographics.org/releases/pixman-%PIXMAN_VERSION%.tar.gz -O
	curl http://www.cairographics.org/releases/cairo-%CAIRO_VERSION%.tar.xz -O
	curl http://download.icu-project.org/files/icu4c/4.8.1.1/icu4c-4_8_1_1-src.tgz -O
	curl ftp://xmlsoft.org/libxml2/libxml2-%LIBXML2_VERSION%.tar.gz -O
	curl http://iweb.dl.sourceforge.net/project/expat/expat_win32/%EXPAT_VERSION%/expat-win32bin-%EXPAT_VERSION%.exe -O
	curl http://download.osgeo.org/gdal/gdal-%GDAL_VERSION%.tar.gz -O
	curl http://www.sqlite.org/2013/sqlite-amalgamation-%SQLITE_VERSION%.zip -O
	curl http://download.osgeo.org/proj/proj-%PROJ_VERSION%.tar.gz -O
	curl http://download.osgeo.org/proj/proj-datumgrid-%PROJ_GRIDS_VERSION%.zip -O
	curl http://download.osgeo.org/geos/geos-%GEOS_VERSION%.tar.bz2 -O

	cd %ROOTDIR%

## Building individual packages

### ICU

	bsdtar xvfz %PKGDIR%\icu4c-4_8_1_1-src.tgz
	rem Update project to vc++ 2012
	cd icu/
	msbuild source\allinone\allinone.sln /t:Rebuild  /p:Configuration="Release" /p:Platform=x64
	cd %ROOTDIR%

### boost

	bsdtar xzf %PKGDIR%/boost_1_%BOOST_VERSION%_0.tar.gz
	cd boost_1_%BOOST_VERSION%_0
	set BOOST_PREFIX=boost-%BOOST_VERSION%-vc110
	bootstrap.bat
	bjam toolset=msvc --prefix=..\\%BOOST_PREFIX% --with-thread --with-filesystem --with-date_time --with-system --with-program_options --with-regex --with-chrono --disable-filesystem2 -sHAVE_ICU=1 -sICU_PATH=%ROOTDIR%\\icu -sICU_LINK=%ROOTDIR%\\icu\\lib64\\icuuc.lib release link=static --build-type=complete address-model=64 install

##### Python 2.7

Configure Python in user-config.jam - at the end of file add

	using python : 2.7 : c:/python27/python.exe ;

	bjam toolset=msvc --prefix=..\\%BOOST_PREFIX% --with-python --python=2.7 release link=shared --build-type=complete address-model=64 install

### Jpeg

	unzip %PKGDIR%\jpegsr%JPEG_VERSION%.zip
	rename jpeg-%JPEG_VERSION% jpeg
	cd jpeg
	unzip %PKGDIR%\jpegsr%JPEG_VERSION%.zip
	rename jpeg-%JPEG_VERSION% jpeg
	cd jpeg
	// Microsoft dropped support for command line tools
	// and there is no win32.mak in VC++ 2012 install :)
	//  1. Download Windows SDKs (7.0a)
	//  2. Locate and copy win32.mak into %ROOTDIR%/jpeg e.g
	//  copy "c:\Program Files\Microsoft SDKs\Windows\v7.1\Include\Win32.Mak" .
	//  3. Create vc++ 2012 (vc100) project files
	nmake /f makefile.vc CPU=AMD64 setup-v10
	// open in vc++ 2012 and upgrade solution to vc110
	// make sure you save all changes !!
	msbuild jpeg.vcxproj /t:Rebuild  /p:Configuration="Release" /p:Platform=x64
	copy x64\Release\jpeg.lib .
	cd %ROOTDIR%

### Freetype

	bsdtar xfz "%PKGDIR%\freetype-%FREETYPE_VERSION%.tar.gz"
	rename freetype-%FREETYPE_VERSION% freetype
	cd freetype

	// manually upgrade to x64 / Release Multithreaded
	open in vc++2012 : builds\win32\vc2010\freetype.sln
	...
	save all on exit!!
	msbuild builds\win32\vc2010\freetype.sln /p:Configuration="Release Multithreaded" /p:Platform=x64 /t:Rebuild
	cd %ROOTDIR%

### zlib

zlib comes with old VC++ project files. Instead we use upgraded project file from libpng:

	bsdtar xvfz %PKGDIR%\libpng-%LIBPNG_VERSION%.tar.gz
	rename libpng-%LIBPNG_VERSION% libpng

	bsdtar xvfz %PKGDIR%\zlib-%ZLIB_VERSION%.tar.gz
	rename zlib-%ZLIB_VERSION% zlib
	mkdir %ROOTDIR%\zlib\projects\visualc71
	cd %ROOTDIR%\zlib\projects\visualc71
	copy %ROOTDIR%\libpng\projects\visualc71\zlib.vcproj .

	vcupgrade zlib.vcproj
	msbuild zlib.vcxproj /t:Rebuild /p:Configuration="LIB Release" /p:Platform=x64
	cd %ROOTDIR%\zlib
	move "projects\visualc\x64\LIB Release\zlib.lib" zlib.lib
	cd  %ROOTDIR%

### libpng

Upgrade to VS2012 64-bit project

	cd %ROOTDIR%\libpng\projects\visualc71
	msbuild libpng.vcxproj /t:Rebuild  /p:Configuration="LIB Release" /p:Platform=x64
	move "projects\visualc71\x64\LIB Release\libpng.lib" libpng.lib

### libpq (PostgreSQL C-interface)

	bsdtar xvfz "%PKGDIR%\postgresql-%POSTGRESQL_VERSION%.tar.gz"
	rename postgresql-%POSTGRESQL_VERSION% postgresql
	cd postgresql\src
	nmake /f win32.mak CPU=AMD64
	cd %ROOTDIR%
	move src\interfaces\libpq\Release\libpq.lib .

### Tiff

	bsdtar xvfz %PKGDIR%\tiff-%TIFF_VERSION%.tar.gz
	rename tiff-%TIFF_VERSION% tiff
	cd tiff
	set P1=s/\^#JPEG_SUPPORT.*/JPEG_SUPPORT = 1/;
	set P2=s/\^#JPEGDIR.*/JPEGDIR = %ROOTDIR:\=\\\%\\\jpeg/;
	set P3=s/\^#JPEG_INCLUDE/JPEG_INCLUDE/;
	set P4=s/\^#JPEG_LIB.*/JPEG_LIB = \$(JPEGDIR^)\\\libjpeg.lib/;
	set P5=s/\^#ZIP_SUPPORT.*/ZIP_SUPPORT = 1/;
	set P6=s/\^#ZLIBDIR.*/ZLIBDIR = %ROOTDIR:\=\\\%\\\zlib/;
	set P7=s/\^#ZLIB_INCLUDE/ZLIB_INCLUDE/;
	set P8=s/\^#ZLIB_LIB.*/ZLIB_LIB = \$(ZLIBDIR^)\\\zlib.lib/;
	set PATTERN="%P1%%P2%%P3%%P4%%P5%%P6%%P7%%P8%"
	sed %PATTERN%  nmake.opt > nmake.opt.fixed
	move /Y nmake.opt.fixed nmake.opt
	nmake /f Makefile.vc
	cd %ROOTDIR%
	copy libtiff\libtiff.lib .

### WEBP

    bsdtar xvzf  %PKGDIR%\libwebp-%WEBP_VERSION%.tar.gz
    cd  webp
    nmake /f Makefile.vc CFG=release-static RTLIBCFG=static OBJDIR=output ARCH=x64
    cd %ROOTDIR%

### Pixman

	bsdtar xvfz %PKGDIR%\pixman-%PIXMAN_VERSION%.tar.gz
	rename pixman-%PIXMAN_VERSION% pixman
	cd pixman\pixman
	make -f Makefile.win32 CFG=release MMX=off SSE2=on
	cd %ROOTDIR%

### Cairo

	bsdtar xvfz %PKGDIR%\cairo-%CAIRO_VERSION%.tar.gz
	rename cairo-%CAIRO_VERSION% cairo
	cd cairo
	set INCLUDE=%INCLUDE%;%ROOTDIR%\zlib
	set INCLUDE=%INCLUDE%;%ROOTDIR%\libpng
	set INCLUDE=%INCLUDE%;%ROOTDIR%\pixman\pixman
	set INCLUDE=%INCLUDE%;%ROOTDIR%\cairo\boilerplate
	set INCLUDE=%INCLUDE%;%ROOTDIR%\cairo
	set INCLUDE=%INCLUDE%;%ROOTDIR%\cairo\src
	set INCLUDE=%INCLUDE%;%ROOTDIR%\freetype\include
	make -f Makefile.win32 "CFG=release"
	@rem - delete bogus cairo-version.h
	@rem https://github.com/mapnik/mapnik-packaging/issues/56
	del src\cairo-version.h
	del
	cd %ROOTDIR%

### LibXML2

	bsdtar xvfz %PKGDIR%\libxml2-%LIBXML2_VERSION%.tar.gz
	rename libxml2-%LIBXML2_VERSION% libxml2
	cd libxml2\win32
	cscript configure.js compiler=msvc prefix=%ROOTDIR%\libxml2 iconv=no icu=yes include=%ROOTDIR%\icu\include lib=%ROOTDIR%\icu\lib
	nmake /f Makefile.msvc
	cd %ROOTDIR%

### Proj4

#### Official release

	bsdtar xfz %PKGDIR%\proj-%PROJ_VERSION%.tar.gz
	rename proj-%PROJ_VERSION% proj
	cd proj/nad
	unzip -o ../../packages/proj-datumgrid-%PROJ_GRIDS_VERSION%.zip
	cd ..\
	nmake /f Makefile.vc
	cd %ROOTDIR%

### Expat (for GDAL's KML,GPX, GeoRSS read support)

	Download source untar as usual, untar and rename dir to 'expat'
	open vc++ 6 *.dsw project file in vc++ 2012,  upgrade and save changes.
	(specifically we're interseted in expat_static sub-project, ensure it's linked to correct runtime /MD etc etc)
	msbuild lib\expat_static.vcxproj  /t:Rebuild  /p:Configuration="Release" /p:Platform=x64
	copy win32\bin\Release\libexpat.lib .
	cd %ROOTDIR%

### GDAL

	bsdtar xvfz %PKGDIR%\gdal-%GDAL_VERSION%.tar.gz
	rename gdal-%GDAL_VERSION% gdal
	cd gdal

	@rem Edit the 'name.opt' to point to the location the expat binary was installed to:
	@rem EXPAT_DIR="C:\Program Files (x86)\Expat 2.1.0"

	nmake /f makefile.vc MSVC_VER=1700 WIN64=YES
	cd %ROOTDIR%

### sqlite

*NOTE: there's no build step for sqlite, we simply unzip archive and rename dir*

	unzip %PKGDIR%\sqlite-amalgamation-%SQLITE_VERSION%.zip
	rename sqlite-amalgamation-%SQLITE_VERSION% sqlite
