


                         Java Example 3


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

    $ java -classpath ${CLASSPATH}:../../../lib/statemap.jar checkstring <string>

Windows:

    $ java -classpath ${CLASSPATH};../../../lib/statemap.jar checkstring <string>

Try several different strings, such as:

    $ java -classpath ${CLASSPATH}:../../../lib/statemap.jar checkstring ""
      -> unacceptable
    $ java -classpath ${CLASSPATH}:../../../lib/statemap.jar checkstring 00
      -> unacceptable
    $ java -classpath ${CLASSPATH}:../../../lib/statemap.jar checkstring 1c
      -> unacceptable
    $ java -classpath ${CLASSPATH}:../../../lib/statemap.jar checkstring c0
      -> unacceptable
    $ java -classpath ${CLASSPATH}:../../../lib/statemap.jar checkstring abcba
      -> unacceptable
    $ java -classpath ${CLASSPATH}:../../../lib/statemap.jar checkstring 110010c010011
      -> acceptable
    $ java -classpath ${CLASSPATH}:../../../lib/statemap.jar checkstring 110010c110010
      -> unacceptable
