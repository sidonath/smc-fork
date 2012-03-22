                         Java Example 3

This state machine "recognizes" the palindromes (words that read the
same backwards as forwards). The words consist of the alphabet
{0, 1, c} where the letter 'c' may appear only once and marks the
word's center.

This ant build.xml was provided courtesy of Eitan Suez.


+ Building
----------

NOTE: Smc.jar must be built and installed.

Unix & Windows:
    $ ant


+ Executing
-----------

Try several different strings, such as:

    $ java -classpath ${CLASSPATH}:../../../lib/Java/statemap.jar:build/classes checkstring ""
      -> unacceptable
    $ java -classpath ${CLASSPATH}:../../../lib/Java/statemap.jar:build/classes checkstring 00
      -> unacceptable
    $ java -classpath ${CLASSPATH}:../../../lib/Java/statemap.jar:build/classes checkstring 1c
      -> unacceptable
    $ java -classpath ${CLASSPATH}:../../../lib/Java/statemap.jar:build/classes checkstring c0
      -> unacceptable
    $ java -classpath ${CLASSPATH}:../../../lib/Java/statemap.jar:build/classes checkstring abcba
      -> unacceptable
    $ java -classpath ${CLASSPATH}:../../../lib/Java/statemap.jar:build/classes checkstring 110010c010011
      -> acceptable
    $ java -classpath ${CLASSPATH}:../../../lib/Java/statemap.jar:build/classes checkstring 110010c110010
      -> unacceptable
