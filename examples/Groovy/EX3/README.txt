


                         Groovy Example 3


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

Unix:

    $ groovy -classpath ${CLASSPATH}:../../../lib/Groovy/statemap.jar checkstring <string>

Windows:

    $ groovy -classpath ${CLASSPATH};../../../lib/Groovy/statemap.jar checkstring <string>

Try several different strings, such as:

    $ groovy -classpath ${CLASSPATH}:../../../lib/Groovy/statemap.jar checkstring ""
      -> unacceptable
    $ groovy -classpath ${CLASSPATH}:../../../lib/Groovy/statemap.jar checkstring 00
      -> unacceptable
    $ groovy -classpath ${CLASSPATH}:../../../lib/Groovy/statemap.jar checkstring 1c
      -> unacceptable
    $ groovy -classpath ${CLASSPATH}:../../../lib/Groovy/statemap.jar checkstring c0
      -> unacceptable
    $ groovy -classpath ${CLASSPATH}:../../../lib/Groovy/statemap.jar checkstring abcba
      -> unacceptable
    $ groovy -classpath ${CLASSPATH}:../../../lib/Groovy/statemap.jar checkstring 110010c010011
      -> acceptable
    $ groovy -classpath ${CLASSPATH}:../../../lib/Groovy/statemap.jar checkstring 110010c110010
      -> unacceptable
