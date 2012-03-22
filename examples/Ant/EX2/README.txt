                         Java Example 2

This state machine "recognizes" the string 0*1*. Example 2 differs
from example 1 in that example 2 uses default transitions.

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
      -> acceptable
    $ java -classpath ${CLASSPATH}:../../../lib/Java/statemap.jar:build/classes checkstring 000
      -> acceptable
    $ java -classpath ${CLASSPATH}:../../../lib/Java/statemap.jar:build/classes checkstring 00011
      -> acceptable
    $ java -classpath ${CLASSPATH}:../../../lib/Java/statemap.jar:build/classes checkstring 111
      -> acceptable
    $ java -classpath ${CLASSPATH}:../../../lib/Java/statemap.jar:build/classes checkstring 000111100
      -> unacceptable
    $ java -classpath ${CLASSPATH}:../../../lib/Java/statemap.jar:build/classes checkstring 00011a1b10c0
      -> unacceptable
