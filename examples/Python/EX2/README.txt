


                         Python Example 2


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

    $ python checkstring.py <string>

Try several different strings, such as:

    $ python checkstring.py ""
      -> acceptable
    $ python checkstring.py 000
      -> acceptable
    $ python checkstring.py 00011
      -> acceptable
    $ python checkstring.py 111
      -> acceptable
    $ python checkstring.py 000111100
      -> unacceptable
    $ python checkstring.py 00011a1b10c0
      -> unacceptable
