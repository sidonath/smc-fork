


                          Python/Tkinter Example 4


Simplistic, graphical simulation of a stoplight. Demonstrates
how to use state machines to handle external events (in this case
timeouts).


+ Building
----------

NOTE: Smc.jar must be built and installed.

Unix & Windows:
    $ make all

(Note: -g is optional and needed only for observing the FSM
       debug output.)

To turn on the debug output, do the following:

    1. Compile Stoplight.sm and Vehicle.sm with the -g command
       line option.

    2. In Vehicle.py and Stoplight.py, uncomment the call
       setDebugFlag(True).

       You may not want to turn on the Vehicle.sm debug output
       since it is quite verbose.


+ Executing
-----------

Unix & Windows

    $ python traffic.py

    Click on the "Configure..." button and modify the demo's
    settings. Increase the vehicle speed and appearance
    rate. Decrease the stoplight times.

    Also, click on "Pause" and "Continue". "Stop" halts the
    demonstration but does not terminate the demo.

