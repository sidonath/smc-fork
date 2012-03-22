


                         Lua Example 3


This state machine "recognizes" the palindromes (words that read the
same backwards as forwards). The words consist of the alphabet
{0, 1, c} where the letter 'c' may appear only once and marks the
words center.


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
      -> unacceptable
    $ lua checkstring.lua 00
      -> unacceptable
    $ lua checkstring.lua 1c
      -> unacceptable
    $ lua checkstring.lua c0
      -> unacceptable
    $ lua checkstring.lua abcba
      -> unacceptable
    $ lua checkstring.lua 110010c010011
      -> acceptable
    $ lua checkstring.lua 110010c110010
      -> unacceptable
