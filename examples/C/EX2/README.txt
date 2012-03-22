


                          C Example 2


This state machine "recognizes" the string 0*1* (which includes the
empty string). This second example differs from the first in that
it uses default transitions.


+ Building
----------

NOTE: Smc.jar must be built and installed.

Unix & Windows (MinGW):
    $ make checkstring


+ Executing
-----------

Unix & Windows:

    $ checkstring <string>

Try several different strings, such as:

    $ checkstring "" -> acceptable
    $ checkstring 000 -> acceptable
    $ checkstring 00011 -> acceptable
    $ checkstring 111 -> acceptable
    $ checkstring 000111100 -> unacceptable
    $ checkstring 00011a1b10c0 -> unacceptable
