


                         Lua Example 2


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

    $ lua checkstring.lua <string>

Try several different strings, such as:

    $ lua checkstring.lua ""
      -> acceptable
    $ lua checkstring.lua 000
      -> acceptable
    $ lua checkstring.lua 00011
      -> acceptable
    $ lua checkstring.lua 111
      -> acceptable
    $ lua checkstring.lua 000111100
      -> unacceptable
    $ lua checkstring.lua 00011a1b10c0
      -> unacceptable

