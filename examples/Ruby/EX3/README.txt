


                         Ruby Example 3


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

    $ ruby checkstring.rb <string>

Try several different strings, such as:

    $ ruby checkstring.rb ""
      -> unacceptable
    $ ruby checkstring.rb 00
      -> unacceptable
    $ ruby checkstring.rb 1c
      -> unacceptable
    $ ruby checkstring.rb c0
      -> unacceptable
    $ ruby checkstring.rb abcba
      -> unacceptable
    $ ruby checkstring.rb 110010c010011
      -> acceptable
    $ ruby checkstring.rb 110010c110010
      -> unacceptable
