

                               SMC
                     The State Machine Compiler
                         (Version: 6.0.2)

                     http://smc.sourceforge.net



0. What's New?
--------------

Major changes:

None


Minor changes:

(Java)
    -access keyword to specify the generated class access level.
    Used with -java only.

(All)
    Added %fsmclass keyword which allows the generated FSM
    classes to have a name other than the default
    <app class>Context. This feature allows an application class
    to reference multiple finite state machines.

(C#, Groovy, Java, Lua, Perl, PHP, Python, Ruby, Scala, Tcl and VB.Net)
    Added "getStates" method for retrieving the finite state
    machine's states.

(All)
    Enhance debugging output by adding command line options -g0
    and -g1 which provide ever greater debug output. -g is the
    same as -g0. -g0 reports the exiting and entering a state,
    entering and exiting a transtion. -g1 reports exit and entry
    action execution.

(C#, VB.Net)
    Added -generic support to these languages.


Bug Fixes:

(Objective-C)
    Corrected generated code errors.

(Php)
    statemap.php had an assignment in a test condition instead of
    equality operator.

(All)
    Strings using both single and double quotes are handled
    correctly.

(Java)
    Errors due to lower case state names corrected.

(Java)
    Serializing the FSM property change listeners is corrected.

(Python)
    The problem occurring when raising the
    StateUndefinedException is now fixed.

(All)
    Compiler warnings are now output even when there are no
    errors.

(All)
    Normalized the use of emptyStateStack.



1. System Requirements
----------------------

+ JRE (Standard Edition) 1.6.0 or better.
+ Whatever JRE's requirements are (see http://java.sun.com/j2se/
  for more information).


2. Introduction
---------------

If you use state machines to define your objects behavior and are
tired of the time-consuming, error-prone work of implementing
those state machines as state transition matrices or widely
scattered switch statements, then SMC is what you're looking for.

SMC takes a state machine definition and generates State pattern
classes implementing that state machine. The only code you need
to add to your object is 1) create the state machine object and
2) issue transitions. ITS THAT EASY.

+ NO, you don't have to inherit any state machine class.
+ NO, you don't have to implement any state machine interface.

YES, you add to your class constructor:

        _myFSM = new MyClassContext(this);

YES, you issue state transitions:

        _myFSM.HandleMessage(msg);

Congratulations! You've integrated a state machine into your
object.

SMC is written in Java and is truly "Write once, run anywhere".
If you have at least the Java Standard Edition v. 1.6.0 loaded,
then you can run SMC (if you have the Java Enterpise Edition, so
much the better!)

Java Standard Edition can be downloaded for FREE from

                    http://java.sun.com/j2se/

SMC currently supports fourteen programming languages:
  1. C,
  2. C++,
  3. C#,
  4. Groovy,
  5. Java,
  6. Lua,
  7. Objective-C,
  8. Perl,
  9. PHP,
 10. Python,
 11. Ruby,
 12. Scala,
 13. [incr Tcl] and
 14. VB.Net.

SMC is also able to generate an HTML table representation of your
FSM and a GraphViz DOT file representation
(http://www.graphviz.org).


3. Download
-----------

Surf over to http://smc.sourceforge.net and check out
"File Releases". The latest SMC version is 6.0.0.
SMC downloads come in two flavors: tar/gzip (for Unix)
and self-extracting zip file (for Windows).

The download package contains the executable Smc.jar and
supporting library: statemap.h (for C++), statemap.jar
(for Java), statemap.tcl & pkgIndex.tcl (for Tcl),
statemap.dll (for VB.Net) and statemap.dll (for C#).

NOTE: Only the SMC-generated code uses these libraries. Your code
doesn't even know they exist. However, when compiling your
application, you will need to add a
    -I<path to statemap.h directory>
or
    -classpath ...:<path to statemap.jar>
to your compile command (when running you Java application, you
also need to add statemap.jar to your classpath).

The download package's directory layout is:

    Smc -+-LICENSE.txt
         |
         +-README.txt
         |
         +-bin---Smc.jar 
         |
         +-docs-+-SMC_Tutorial.pdf
         |      |
         |      +-javadocs--(javadoc html files)
         |
         +-lib-+-statemap.h
         |     |
         |     +-statemap.jar
         |     |
         |     +-C---statemap.h
         |     |
         |     +-C++---statemap.h
         |     |
         |     +-DotNet-+-Debug-+-NoTrace-+-statemap.dll
         |     |        |       |         |
         |     |        |       |         +-statemap.pdb
         |     |        |       |
         |     |        |       +-Trace---+-statemap.dll
         |     |        |                 |
         |     |        |                 +-statemap.pdb
         |     |        |
         |     |        +-Release-+-NoTrace--statemap.dll
         |     |                  |
         |     |                  +-Trace----statemap.dll
         |     |
         |     +-Java-+-SmcGenerator.jar
         |     |      |
         |     |      +-SmcModel.jar
         |     |      |
         |     |      +-SmcParser.jar
         |     |      |
         |     |      +-statemap.jar
         |     |      |
         |     |      +-statemap-+-FSMContext.class
         |     |                 |
         |     |                 +-State.class
         |     |                 |
         |     |                 +-StateUndefinedException.class
         |     |                 |
         |     |                 +-TransitionUndefinedException.class
         |     |
         |     +-Lua--+-README
         |     |      |
         |     |      +-statemap.h
         |     |
         |     +-ObjC-+-README.txt
         |     |      |
         |     |      +-statemap.h
         |     |      |
         |     |      +-statemap.m
         |     |
         |     +-Perl-+-MANIFEST
         |     |      |
         |     |      +-Makefile.pl
         |     |      |
         |     |      +-README
         |     |      |
         |     |      +-Statemap.pm
         |     |      |
         |     |      +-test.pl
         |     |
         |     +-Php-+-README.txt
         |     |     |
         |     |     +-package.xml
         |     |     |
         |     |     +-statemap.php
         |     |
         |     +-Python-+-README.py
         |     |        |
         |     |        +-setup.py
         |     |        |
         |     |        +-statemap.py
         |     |
         |     +-Ruby-+-README
         |     |      |
         |     |      +-statemap.rb
         |     |
         |     +-Scala-+-statemap.jar
         |     |       |
         |     |       +-statemap.scala
         |     +-Tcl-+-statemap1.0-+-statemap.tcl
         |                         |
         |                         +-pkgIndex.tcl
         |
         +-misc-+-smc.ico (smc Windows icon)
         |
         +-examples-+-Ant--+-EX1 (Java source code, Ant built)
         |          |      |
         |          |      +-EX2
         |          |      |
         |          |      +-EX3
         |          |      |
         |          |      +-EX4
         |          |      |
         |          |      +-EX5
         |          |      |
         |          |      +-EX6
         |          |      |
         |          |      +-EX7
         |          |
         |          +-C----+-EX1 (C source code, Makefiles)
         |          |      |
         |          |      +-EX2
         |          |      |
         |          |      +-EX3
         |          |      |
         |          |      +-EX4
         |          |
         |          +-C++--+-EX1 (C++ source code, Makefiles)
         |          |      |
         |          |      +-EX2
         |          |      |
         |          |      +-EX3
         |          |      |
         |          |      +-EX4
         |          |      |
         |          |      +-EX5
         |          |      |
         |          |      +-EX6
         |          |
         |          +-CSharp-+-EX1 (C# source code)
         |          |        |
         |          |        +-EX2
         |          |        |
         |          |        +-EX3
         |          |
         |          +-Java-+-EX1 (Java source code, Makefiles)
         |          |      |
         |          |      +-EX2
         |          |      |
         |          |      +-EX3
         |          |      |
         |          |      +-EX4
         |          |      |
         |          |      +-EX5
         |          |      |
         |          |      +-EX6
         |          |      |
         |          |      +-EX7
         |          |
         |          +-Lua--+-EX1 (Lua source code)
         |          |      |
         |          |      +-EX2
         |          |      |
         |          |      +-EX3
         |          |
         |          +-ObjC-+-EX1 (Objective C source code)
         |          |      |
         |          |      +-EX2
         |          |      |
         |          |      +-EX3
         |          |      |
         |          |      +-EX4
         |          |      |
         |          |      +-EX5
         |          |      |
         |          |      +-EX7 (Mac OSX XCode Project)
         |          |
         |          +-Perl-+-EX1 (Perl source code)
         |          |      |
         |          |      +-EX2
         |          |      |
         |          |      +-EX3
         |          |      |
         |          |      +-EX4
         |          |      |
         |          |      +-EX7
         |          |
         |          |
         |          +-Python-+-EX1 (Python source code)
         |          |        |
         |          |        +-EX2
         |          |        |
         |          |        +-EX3
         |          |        |
         |          |        +-EX4
         |          |        |
         |          |        +-EX7
         |          |
         |          +-Ruby-+-EX1 (Ruby source code)
         |          |      |
         |          |      +-EX2
         |          |      |
         |          |      +-EX3
         |          |      |
         |          |      +-EX4
         |          |      |
         |          |      +-EX7
         |          |
         |          +-Tcl--+-EX1 (Tcl source code)
         |          |      |
         |          |      +-EX2
         |          |      |
         |          |      +-EX3
         |          |      |
         |          |      +-EX4
         |          |      |
         |          |      +-EX5
         |          |
         |          +-VB---+-EX1 (VB.Net source code)
         |                 |
         |                 +-EX2
         |                 |
         |                 +-EX3
         |                 |
         |                 +-EX4
         |
         +-tools-+-maven-+-plugin.jelly
                 |       |
                 |       +-plugin.properties
                 |       |
                 |       +-project.xml
                 |
                 +-smc-anttask-+-.classpath
                               |
                               +-.project
                               |
                               +-build.xml
                               |
                               +-smc-anttask.iml
                               |
                               +-smc-anttask.ipr
                               |
                               +-smc-anttask.iws
                               |
                               +-build---classes---...
                               |
                               +-dist---smc-ant.jar
                               |
                               +-lib---ant.jar
                               |
                               +-src---net---sf---smc---ant---SmcJarWrapper.java


4. Installation
---------------

After downloading SMC (either tar/gzip or self-extracting zip
file), you install SMC as follows:

1. Figure out where you can to load the Smc directory and place
   the SMC package there.
2. If you already have an "smc" directory/folder, change its name
   to something like "smc_old" or "smc_1_2_0". This will prevent
   its contents from being overwritten in case you want to back
   out of the new version. Once you are satisfied with the new
   version, you may delete the old SMC.
3. Load the SMC package:
    (Unix) $ tar xvfz Smc_6_0_0.tgz
    (Windows) running Smc_6_0_0.zip

You're done! There really is nothing more that needs to be done.
You may want to take the following steps.

+ Add the full path to .../Smc/bin to your PATH environment
  variable.
+ Add the full path to statemap.jar to your CLASSPATH environment
  variable.
+ Add the full path to .../Smc/lib to your TCLLIBPATH environment
  variable.

The tools directory includes a Maven plug-in
(http://www.maven.org) and an ant task to help integrate SMC
into other development environments.

An Eclipse plug-in is not yet available.


5. Examples
-----------

The examples directory contains example SMC-based applications.
The examples range from trivial (EX1) to sophisticated (EX5).
Use these examples together with the SMC Programmer's Guide to
learn how to use SMC.

The C++ examples provide Makefiles, Microsoft DevStudio 6.0
workspace and DevStudio 7.0 solution.

The Java examples in examples/Java use "make" for building.
The same examples also appear in examples/Ant and use "ant".

The [incr Tcl] examples are not built and require you to
execute "java -jar Smc.jar" by hand.

The VB.Net and C# examples use DevStudio 7.0.

To learn more about each example and how to build & run each one,
read the example's README.txt.


6. FAQ/Documentation/Reporting Bugs/Latest News
-----------------------------------------------

Surf over to http://smc.sourceforge.net to:

+ Read the SMC Frequently Asked Questions (FAQ).
+ Download documentation - including the SMC Programmer's Guide.
+ Talk with other SMC users in Public Forums.
+ Report bugs.
+ Get the latest news about SMC.
+ Access SMC source code via a CVS web interface.
+ Check out docs/SMC_Tutorial.pdf.


7. Notices
----------

This software is OSI Certified Open Source Software.
OSI Certified is a certification mark of the Open Source Initiative.
