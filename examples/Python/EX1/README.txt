


                          Python Example 1


This state machine "recognizes" the string 0*1* (which includes the
empty string).


+ Building
----------

NOTE: Smc.jar must be built and installed.

Unix & Windows:
    $ make checkstring


+ Executing
-----------

Unix & Windows

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
