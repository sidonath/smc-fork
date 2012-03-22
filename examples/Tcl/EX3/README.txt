


                          Tcl Example 3


This state machine "recognizes" the palindromes (words that read the
same backwards as forwards). The words consist of the alphabet
{0, 1, c} where the letter 'c' may appear only once and marks the
words center.


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
      -> unacceptable
      
    $ tclsh checkstring.tcl 00
      -> unacceptable
      
    $ tclsh checkstring.tcl 1c
      -> unacceptable
      
    $ tclsh checkstring.tcl c0
      -> unacceptable
      
    $ tclsh checkstring.tcl abcba
      -> unacceptable

    $ tclsh checkstring.tcl 110010c010011
      -> acceptable

    $ tclsh checkstring.tcl 110010c110010
      -> unacceptable
