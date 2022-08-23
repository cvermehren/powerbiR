## Resubmission
This is a resubmission. In this version I have:

* Changed the Description text so that it does not start with 'This package...'

* Put software names and APIs in single quote in the title and description in 
  the DESCRIPTION file.

* Added more details about the package functionality and implemented
  methods in the Description text.

## R CMD check results
There were no ERRORs or WARNINGs. 

There were 2 NOTES: 

## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)

## R CMD check results
* On windows-x86_64-devel (r-devel), ubuntu-gcc-release (r-release), 
  fedora-clang-devel (r-devel)
  checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Christian Vermehren <cv@cantab.net>'
  
  New submission

* On windows-x86_64-devel (r-devel)
  checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
   'lastMiKTeXException'

As noted in R-hub issue #503 (https://github.com/r-hub/rhub/issues/503), 
lastMiKTeXException could be due to a bug/crash in MiKTeX and can likely be 
ignored.
