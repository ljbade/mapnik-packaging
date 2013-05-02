@echo off

set STARTTIME=%TIME%
set ROOTDIR=c:\mapnik_build
@rem note - MAPNIK_DEPS_DIR and MAPNIK_SOURCE
@rem are needed by bjam files
@rem so do not rename or remove them

set MAPNIK_DEPS_DIR=%ROOTDIR%
set MAPNIK_SOURCE=%ROOTDIR%\mapnik
set BOOST_VERSION=53
set BOOST_PREFIX=boost-%BOOST_VERSION%-vc110
set BOOST_INCLUDES=%ROOTDIR%\%BOOST_PREFIX%\include\boost-1_%BOOST_VERSION%
set BOOST_LIBS=%ROOTDIR%\%BOOST_PREFIX%\lib
set PREFIX=c:\mapnik-win64
set PATH=%ROOTDIR%\boost_1_%BOOST_VERSION%_0;%PATH%

@rem copy sparsehash - TODO add this copy to the Jamroot
@rem xcopy /i /s %MAPNIK_SOURCE%\deps\mapnik\sparsehash %PREFIX%\include\mapnik\sparsehash /Y
@rem xcopy /i /s %MAPNIK_SOURCE%\deps\agg\include %PREFIX%\include\mapnik\agg /Y

@rem copy all libs of dependencies
@rem the rest, needed by libmapnik
@rem copy %ROOTDIR%\cairo\src\release\cairo.dll %PREFIX%\lib\
copy %ROOTDIR%\icu\bin64\icuuc51.dll %PREFIX%\lib\
copy %ROOTDIR%\icu\bin64\icudt51.dll %PREFIX%\lib\
copy %ROOTDIR%\icu\bin64\icuin51.dll %PREFIX%\lib\
copy %ROOTDIR%\libxml2\win32\bin.msvc\libxml2.dll %PREFIX%\lib\
copy %ROOTDIR%\proj\src\proj.dll %PREFIX%\lib\

bjam toolset=msvc -j4 --prefix=%PREFIX% -sBOOST_INCLUDES=%BOOST_INCLUDES% -sBOOST_LIBS=%BOOST_LIBS% -sMAPNIK_DEPS_DIR=%MAPNIK_DEPS_DIR% -sMAPNIK_SOURCE=%MAPNIK_SOURCE% address-model=64 --python=2.7

@rem python - paths.py, printing.py, __init__.py, boost python dll
echo Started at %STARTTIME%, finished at %TIME%

