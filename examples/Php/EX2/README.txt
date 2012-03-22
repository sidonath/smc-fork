


                         PHP Example 2


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

    $ php -q checkstring.php <string>

Try several different strings, such as:

    $ php -q checkstring.php ""
      -> acceptable
    $ php -q checkstring.php 000
      -> acceptable
    $ php -q checkstring.php 00011
      -> acceptable
    $ php -q checkstring.php 111
      -> acceptable
    $ php -q checkstring.php 000111100
      -> unacceptable
    $ php -q checkstring.php 00011a1b10c0
      -> unacceptable
