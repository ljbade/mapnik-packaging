# Build and Package Mapnik ( *c++11 branch*)  for windows 64-bit


This is being tested on windows 7 64 bit.

## Visual Studio versions.

For c++11 support we'll need VS 2012 express plus a latest msvc++ compiler (November 2012 CTP at the time of writing)

## Details

See the building_mapnik_dependencies.md document for building Mapnik dependencies.

Step through it copying and pasting chunks of commands, ensuring they work before
continuing.

This is ideally something that could be automated more in the future but the high
likelhood of failure states means that we've found manually running chunks is the
most sane way to get going.

## TIPS

### 64-bit test

To test address-model of a static library:

``` bash
dumpbin /headers | head -20
```

and look for ```8664 machine (x64)```

### VS 2012 setup

VS 2012 express is a bit shy about 64-bit builds. To enable :

* BUILD -> Configuration Manager

	*-> Platform
		From drop down list select 'New' and then 'x64' based on 'Win32'.
	*-> Configuration
		Release

* PROJECT -> Configuration -> Librarian -> Target Machine : MachineX64 (/MACHINE:x64)


These are working notes on building Mapnik/c++11 branch on windows.
