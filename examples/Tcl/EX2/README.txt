


                          Tcl Example 2


This state machine "recognizes" the string 0*1*. Example 2 differs
from example 1 in that example 2 uses default transitions.


+ Building
----------

NOTE: Smc.jar must be built and installed.

Unix & Windows:
    $ java -jar ../../../bin/Smc.jar -tcl AppClass.sm


+ Executing
-----------

Unix & Windows

    $ tclsh checkstring.tcl <string>

Try several different strings, such as:

    $ tclsh checkstring.tcl ""
      -> acceptable
      
    $ tclsh checkstring.tcl 000
      -> acceptable
      
    $ tclsh checkstring.tcl 00011
      -> acceptable
      
    $ tclsh checkstring.tcl 111
      -> acceptable
      
    $ tclsh checkstring.tcl 000111100
      -> unacceptable
      
    $ tclsh checkstring.tcl 00011a1b10c0
      -> unacceptable
