


                         C# Example 3


This state machine "recognizes" palindromes (words that read the
same backwards as forwards). The words consist of the alphabet
{0, 1, c} where the letter 'c' may appear only once and marks the
word's center.


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
      The string "" is not acceptable.
    $ checkstring 00
      The string "00" is not acceptable.
    $ checkstring 1c
      The string "1c" is not acceptable.
    $ checkstring c0
      The string "c0" is not acceptable.
    $ checkstring abcba
      The string "abcba" is not acceptable.
    $ checkstring 110010c010011
      The string "110010c010011" is acceptable.
    $ checkstring 110010c110010
      The string "110010c110010" is not acceptable.
