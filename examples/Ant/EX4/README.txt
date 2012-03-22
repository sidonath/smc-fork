                         Java Example 4

Simplistic, graphical simulation of a stoplight. Demonstrates
how to use state machines to handle external events (in this case
timeouts).

This ant build.xml was provided courtesy of Eitan Suez.


+ Building
----------

NOTE: Smc.jar must be built and installed.

Unix & Windows:
    $ ant


+ Executing
-----------

To run:

    $ java -classpath ${CLASSPATH}:../../../lib/Java/statemap.jar:build/classes smc_ex4.Traffic

Click on the "Configure..." button and modify the demo's
settings. Increase the vehicle speed and appearance
rate. Decrease the stoplight times.

Also, click on "Pause" and "Continue". "Stop" halts the
demonstration but does not terminate the demo.

