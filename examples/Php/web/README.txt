


                         PHP Example web


This is an example for building stateless dynamic web pages
with a state machine. It implements a simple RPN calculator
which preserves its state and calculation stack across HTTP
requests with a hidden input field.
Therefore you can navigate through the whole calculation history
with the browser's back and forward buttons, and it is not
possible to put the application in an inconsistent state,
as the well-known "back button" problem with dynamic web pages
arises from discrepancies between server-side session variables
and forms posted by the client-side web browser.
Because the application always posts back to the same index.php
page, loading it e.g. from a bookmark always puts it back to
the start state.


+ Building
----------

NOTE: Smc.jar must be built and installed.
      For generating the graph, dot from the graphviz package
      must be installed.

Unix & Windows:
    $ make statemachine
    $ make graph

Then copy the whole web directory to a location where
Apache (with PHP installed) can read it, on Unix e.g. to
~/public_html/


+ Executing
-----------

Unix & Windows:

    Point your browser to
    http://<web-directory>/web/index.php
