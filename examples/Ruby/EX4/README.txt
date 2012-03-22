


                          Ruby/Tk Example 4


Simplistic, graphical simulation of a stoplight. Demonstrates
how to use state machines to handle external events (in this case
timeouts).


+ Building
----------

NOTE: Smc.jar must be built and installed.

Unix & Windows:
    $ java -jar ../../../bin/Smc.jar -ruby [-g] Stoplight.sm Vehicle.sm

(Note: -g is optional and needed only for observing the FSM
       debug output.)

To turn on the debug output, do the following:

    1. Compile Stoplight.sm and Vehicle.sm with the -g command
       line option.

    2. In Vehicle.rb and Stoplight.rb, uncomment the call
       setDebugFlag(true).

       You may not want to turn on the Vehicle.sm debug output
       since it is quite verbose.


+ Executing
-----------

Unix & Windows

    $ ruby traffic.rb

    Click on the "Configure..." button and modify the demo's
    settings. Increase the vehicle speed and appearance
    rate. Decrease the stoplight times.

    Also, click on "Pause" and "Continue". "Stop" halts the
    demonstration but does not terminate the demo.

