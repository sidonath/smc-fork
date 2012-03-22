


                          Ruby Example 1


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

    $ ruby checkstring.rb <string>

Try several different strings, such as:

    $ ruby checkstring.rb ""
      -> acceptable

    $ ruby checkstring.rb 000
      -> acceptable

    $ ruby checkstring.rb 00011
      -> acceptable

    $ ruby checkstring.rb 111
      -> acceptable

    $ ruby checkstring.rb 000111100
      -> unacceptable

    $ ruby checkstring.rb 00011a1b10c0
      -> unacceptable
