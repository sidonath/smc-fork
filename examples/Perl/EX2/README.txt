


                         Perl Example 2


This state machine "recognizes" the string 0*1*. Example 2 differs
from example 1 in that example 2 uses default transitions.


+ Building
----------

NOTE: Smc.jar must be built and installed.

Unix & Windows:
    $ make checkstring


+ Executing
-----------

Unix & Windows:

    $ perl checkstring.pl <string>

Try several different strings, such as:

    $ perl checkstring.pl ""
      -> acceptable
    $ perl checkstring.pl 000
      -> acceptable
    $ perl checkstring.pl 00011
      -> acceptable
    $ perl checkstring.pl 111
      -> acceptable
    $ perl checkstring.pl 000111100
      -> unacceptable
    $ perl checkstring.pl 00011a1b10c0
      -> unacceptable
