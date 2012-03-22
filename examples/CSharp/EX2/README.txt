


                         C# Example 2


This state machine "recognizes" the string 0*1* (which includes the
empty string).


+ Building
----------

NOTE: Smc.jar must be built and installed.

Windows:
    (Use Microsoft DevStudio v. 7.0 or later.)


+ Executing
-----------

Windows:

    $ cd bin/Debug
      OR
    $ cd bin/Release

    $ checkstring <string>

Try several different strings such as:

    $ checkstring ""
      The string "" is acceptable.
    $ checkstring 000
      The string "000" is acceptable.
    $ checkstring 00011
      The string "00011" is acceptable.
    $ checkstring 111
      The string "111" is acceptable.
    $ checkstring 000111100
      The string "000111100" is not acceptable.
    $ checkstring 00011a1b10c0
      The string "00011a1b10c0" is not acceptable.
