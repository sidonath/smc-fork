                              SMC -
                  The State Machine Compiler
                        Version 6.0.1


+ Major changes
---------------

None.


+ Minor changes
---------------

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


+ Bug fixes
-----------

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



                              SMC -
                  The State Machine Compiler
                        Version 6.0.0


+ Major changes
---------------

(All)
    Smc.jar requires Java 6.

(All)
    Moved source files into three separate directories: model,
    parser and generator. The model directory contains
    SmcElement.java and those classes extending SmcElement.
    The parser directory contains the classes for parsing a .sm
    file. The generator directory contains SmcCodeGenerator.java
    and those classes extending SmcCodeGenerator. Only Smc.java
    and SmcSyntaxChecker.java remains in the original source
    directory.

    There are four jar files built: the original Smc.jar,
    model.jar, parser.jar and generator.jar. Smc.jar uses the
    other three packages to implement the State Machine Compiler.
    The point of dividing SMC into different packages is to open
    SMC's capabilities to other applications. For example, if an
    IDE defines a the finite state machine using the model
    package then the generator package to emit the FSM in a
    target programming language. The new jar files are placed
    in lib/Java.

    This change in source file location does not otherwise affect
    how SMC works.

(All)
    The loopback transition is now divided into external and
    internal loopback transitions. The external loopback is
    specified by using the current state's name as the
    transition's next state. The external loopback executes the
    current state's exit and entry actions. The internal loopback
    uses "nil" as the next state and does not execute the current
    state's exit and entry actions. The internal loopback's
    behavior is the same as the previous loopback transition.

    NOTE: THIS CHANGE MAY BREAK EXISTING CODE.
    If you implemented loopbacks by placing the current state's
    name in the transition next state, then the transition's
    behavior will change. You will need to replace the explicit
    state name with "nil" to maintain existing behavior.
    (SF Feature Request 1876271)

(All)
    The SMC distribution now generates javadocs and places the
    generated HTML files in docs/javadocs. All SMC source files
    now have javadoc comments.


+ Minor changes
---------------

None.


+ Bug fixes
-----------

(PHP, Python)
    Default state fails on transition overloading.
    (SF bug 1905336)

(GraphViz)
    Corrected parser error when code parameter uses "$" as in
    Perl and PHP.
    (SF bug 1930388)

(All)
    Changes lib source file layout regular by making sure all
    source files are stored in a programming language directory.
    (SF bug 1930423, 1934483)

(All)
    Changed FSMContext class constructor so that initial state
    is set in this constructor. Moved call to initial state entry
    action execution from generated context class constructor to
    new enterStartState() method.
    (SF bug 1964266)

(C++)
    Corrected statemap.h to remove compiler warnings.
    (SF bug 1970979)

(Java)
    Corrected passing null previous state to
    PropertyChangeListener.
    (SF bug 2060426)

(Ant)
    Updated ant SmcJarWrapper.java to include all supported
    target programming languages.
    (SF bug 2234925)

(C#, VB)
     Made .Net dll CLS-compliant.
     (SF bug 2378072)

(All)
     Checking if a map has multiple default states.
     (SF bug 2648469)

(All)
     Checking push transition to see if it contains a valid
     state.
     (SF bug 2648472)

(C#)
     Corrected C# reflection code generated when there is an
     overloaded transition name.
     (SF bug 2648516)

(GraphViz)
     Corrected dot file generated when transition action contains
     an "=" operator.
     (SF bug 2657779)

(Java)
     Remove "final" keyword from generated context class
     declaration.
     (SF bug 2672508)

(All)
     Normalized -d and -headerd paths to make sure the specified
     paths use the system file name separator character.
     (SF bug 2677138)

(All)
     Corrected compiler to accept templates with multiple types.
     For example, Map<String, Integer>.
     (SF feature request 2655248)




                              SMC -
                  The State Machine Compiler
                        Version 5.1.0


+ Major changes
---------------

(PHP)
    Added support for PHP programming language (-php).

(Scala)
    Added support for Scala programming language (-scala).


+ Minor changes
---------------

(All)
    Jump transition added. Works the same as a simple transition.


+ Bug fixes
-----------

(C++)
    The TransitionUndefinedException was missing the transition
    name. The transition name is now placed into the exception.
    (SF bug 1890694)

(GraphViz)
    Correctly handles $ in transition arguments.
    (SF bug 1930388)

(Examples)
    Corrected statemap.h -I include path in C++ examples.
    Corrected C++ example 4 #if __GNUC__ condition.
    Corrected C++ example 6 #include.
    Corrected file names in TCL examples 4 and 5.
    Corrected examples "all" rule.
    Corrected #!/interpreter calls in scripts.
    (SF bugs 1934474, 1934479, 1934484, 1934488, 1934494,
     1934497)




                              SMC -
                  The State Machine Compiler
                        Version 5.0.2


+ Minor changes
---------------

(C#, VB.Net)
    Added state change event support using .Net events and
    delegates. There was already some support for this in
    the generated C# code but it worked only for vanilla
    transitions. The state change event is now raised by
    statemap.FSMContext class for all transition types.

    Strangely, the C# generated code did not call
    statemap.FSMContext.SetState but access _state
    directly. This is now corrected.
    (SF feature request 1570050)


+ Bug fixes
-----------

(Java)
    When a push transition is taken, the resulting state change
    is not reported via the property change event.
    (SF bug 1871371)

(Groovy)
    The necessary Groovy library and examples are missing from
    release 5.0.1 package.
    (SF bug 1869984)




                              SMC -
                  The State Machine Compiler
                        Version 5.0.1



+ Major changes
---------------

(Groovy)
    Added support for Groovy programming language (-groovy).

(Java)
    Added state change notification to FSMContext.
    (SF feature request 1570050)

(Programmer's Manual)
    Added section 12: Event Notification which explains how state
    change notification can be used in Java, C# and VB.Net.


+ Bug fixes
-----------

(C++)
    Changed <string> include to <cstring> and fully qualified
    strncpy to std::strncpy.
    (SF bug 1708488)

(C, C++)
    Corrected C and C++ FSM header file include.
    (SF bug 1699854)

(C)
    Corrected error which generated incorrect C code when state
    names began with a lower case letter (state "connected"
    would generate uncompilable C code while "Connected" did
    not).
    (SF bug 1751740)

(Programmer's Manul)
    Corrected C# example code in section 7.
    (SF bug 1711484)

(Python)
    Corrected error where a "pass" clause was incorrectly
    inserted in a non-empty method body of an actionless,
    unguarded, push transition was compiled without the
    -g option.

(Compiler)
    Reading in files as Java chars rather than bytes.
    Java char type is UTF-16 code unit and correctly
    handles 16-bit characters.
    (SF bug 1773868)

(GraphViz)
    When using -glevel 2, a parameterless transition will
    appear to have parameters if the previous transition
    has parameters.
    (SF bug 1823635)



                              SMC -
                  The State Machine Compiler
                        Version 5.0.0



+ Major changes
---------------

Moved to Java 5. SMC cannot be run on Java 1.4.x.


+ Bug fixes
-----------

(All)
    Corrected command line processing bug introduced in v. 4.4.0.
    (SF bug 1659593)

(Makefile)
    Corrected APP_CLASSPATH macro to work in Windows environment.
    (SF bug 1687481)



                              SMC -
                  The State Machine Compiler
                        Version 4.4.0



+ Major changes
---------------

Added Objective-C code generator and examples. Use the command
line option -objc to generate Objective-C header and source
files.

Add Lua code generator and examples. Use the command line option
-lua to generate Lua source file.


+ Minor changes
---------------

(C#, VB.Net)
    Added StateChanged event to the generated context
    class. Registered event handlers are informed when the FSM
    changes state.
    (SF feature 1570050)


+ Bug fixes
-----------

(C++)
    The FSMContext copy constructor C++ statemap.h incorrectly
    included an unused parameter variable name which results in
    compiler warnings. This variable name is removed.
    (SF bug 1580746)

(All)
    SMC -version reported the incorrect version. Corrected in
    this release.
    (SF bug 1580791)

(C++)
    Using the -d with -c++ resulted in generating an invalid
    #include. The #include is now corrected.
    (SF bug 1592619)

(C++)
    Unused local variable loopbackFlag generated, resulting in
    compiler warnings. This variable no longer generated if
    unused.
    (SF bug 1596933)




                              SMC -
                  The State Machine Compiler
                        Version 4.3.3



+ Major changes
---------------

None.

+ Minor changes
---------------

(C#, VB) The _debugFlag and _debugStream are deprecated and no
         longer used. Instead, System.Diagnostics.Trace is
         used. The SMC programmer is responsible for defining
         the TRACE directive during compilation so the Trace
         will be included in the executable.

         The SMC programmer is also responsible for configuring
         Trace to send the trace output to the desired
         destination.

         There are no longer separate C# and VB dlls but a
         single lib/DotNet directory containing four DLLs:
         + debug with Trace support,
         + debug without Trace support,
         + release with Trace support and
         + release without Trace support.
         (SF feature 1440302)


+ Bug fixes
-----------

(C) When -g was used, generated code was not strictly ANSI C
    compliant. This was corrected.
    (SF bug 1550093)

(GraphViz)
    Generated DOT file was incorrect when state names
    begin with a lower-case letter. This was corrected.
    (SF bug 1549777)

(Java)
    Incorrectly generate setOwner() method twice when -serial
    flag is specified.
    (SF bug 1555456)

(C++)
    Removed incorrectly placed semicolon following namespace
    closing brace.
    (SF bug 1556372)

(Python)
    Added missing "pass" statement to empty "else:" block.
    (SF bug 1558366)

(VB)
    Added namespace support. %package is now honored.
    (SF feature request 1544657)




                              SMC -
                  The State Machine Compiler
                        Version 4.3.2



+ Major changes
---------------

None.

+ Minor changes
---------------

(C, C++) Added "-headerd <path>" which specifies where generated
header file is to be placed. This allows for the generated C/C++
source file and header file to be placed into different
locations.

(All) SMC no longer reports an error when a % keyword in .sm
      file is unused for the specified target language.
      (SF feature 1447155)


+ Bug fixes
-----------

(VB) Corrected Owner property set method.
     (SF bug 1504804)

(Python) Corrected indentation for guarded transitions.
         (SF bug 1504907)

(C++) Corrected error in statemap.h: method incorrectly ifdef'ed
      out when -noex option used.
      (SF bug 1517876)



                              SMC -
                  The State Machine Compiler
                        Version 4.3.1



+ Major changes
---------------

None.

+ Minor changes
---------------

(Java) Added FSM constructor which takes two arguments:
the FSM owner and an initial state. Changed state singletons
from package-level statics to public-level static finals so
application code may access them. For example, the state

    MyMap::Connected

is referenced as

    AppClassContext.MyMap.Connected.


+ Bug fixes
-----------

(C#) Corrected error in state Entry and Exit actions where the
context class was set to "null".

(C#) Added property debugStream which allows the debug output
TextWriter to be application-defined. By default the debug
stream is null and no output is written. Turning on debugging
in C# requires setting the Debug property to true and setting
the DebugStream property to a TextWriter object.

(C#, VB) Modified FSM serialization to follow .Net scheme.

(C++) Corrected FSMContext destructor and setDebugFlag method
which delete the _transition pointer even though FSMContext did
not allocate the memory.

(C++) Replaced strcpy calls with strncpy. State and transition
names are now limited to 100 characters by default. However,
this limit can be changed by modifying the statemap.h file.

(Perl) Corrected error where $ctxt variable was not defined
when necessary.

(Python) Corrected code indentation. Incorrect indentation is
a syntax error in Python.



                              SMC -
                  The State Machine Compiler
                        Version 4.3.0



+ Major changes
---------------

Added -reflect option for Java, C#, VB.Net and Tcl code
generation. When used, allows applications to query a state
about its supported transitions. Returns a list of transition
names. This feature is useful to GUI developers who want to
enable/disable features based on the current state. See
Programmer's Manual section 11: On Reflection for more
information.

Updated LICENSE.txt with a missing final paragraph which allows
MPL 1.1 covered code to work with the GNU GPL.


+ Bug fixes
-----------

Fixed GraphViz DOT file generation where double qoutes in
transition guards were not properly escaped.

When generating Java, make getState() public. Also make class
<AppClass>State public.



                              SMC -
                  The State Machine Compiler
                        Version 4.2.2



+ Major changes
---------------

None.


+ Bug fixes
-----------

-csharp broken due to finally block closing brace not
generated.



                              SMC -
                  The State Machine Compiler
                        Version 4.2.1



+ Major changes
---------------

None.


+ Bug fixes
-----------

-java broken due to an untested minor change.



                              SMC -
                  The State Machine Compiler
                        Version 4.2.0



+ Major changes
---------------

Added C, Perl and Ruby language generation.

Added method valueOf(int stateId) to Java, C# and VB.Net to allow
developers to hand-serialize and deserialize state machines.


+ Bug fixes
-----------

(C#) Removed extraneous "bool loopbackFlag = false" line
from Default state transitions.

(C#) Added "Trace.Listeners.Add(myWriter)" line when generating
debug code. By not having this line it prevented debug output
from being outuput.

Corrected parser abend when a transition was missing an endstate.



                              SMC -
                  The State Machine Compiler
                        Version 4.1.0



+ Major changes
---------------

Added a "%access" keyword which sets the generated context
class' accessibility level. This level is used when generating
Java and C# code and ignored for all other target languages.

+ Bug fixes
-----------

(Java) The previous release set the context class' accessibility
level to package if the %package was specified. This was a
mistake. The %access keyword now solves this problem.



                              SMC -
                  The State Machine Compiler
                        Version 4.0.1



+ Major changes
---------------

(No major changes)


+ Bug fixes
-----------

(C++) When the .sm is in a subdirectory the forward- or
backslashes in the file name are kept in the "#ifndef" in the
generated header file. This is syntactically wrong. SMC now
replaces the slashes with underscores.

(Java) If %package is specified in the .sm file, then the
generated *Context.java class will have package-level access.

The Programmer's Manual had incorrect HTML which prevented the
pages from rendering correctly on Internet Explorer.

+ Code changes
--------------

Moved

    private static void _outputMessages(String, List)

to

    public static void outputMessages(String, PrintStream, List)

Compiler messages are now written to the specified
java.io.PrintStream rather than System.err. Also making this
method public allows other SMC tools to access it




                              SMC -
                  The State Machine Compiler
                        Version 4.0.0



+ Major changes
---------------

Moved to Visitor pattern. By rearranging the SMC source code to
the Visitor pattern, it makes it easier to in new code generators
and code analyzers. See http://smc.sourceforge.net/????
for more information about how to add new code generators to SMC.

Added Python code generation. This capability and examples
provided by Francois Perrad, francois.perrad@gadz.org.

When SMC generates C++ and exceptions are allowed (when -noex is
*not* specified), then statemap::FSMContext::popState() throws
a PopOnEmptyStateStackException when a pop transition is taken
but the state stack is empty. Otherwise, assert() is used.

Added a -return command line option which causes Smc.main() to
return rather than exit. This option is needed by ANT users.


+ Bug fixes
-----------

(C++) In statemap.h, the variable id and _id were changed to
stateId and _stateId, respectively. This change was also made to
the generated C++ code. This change was made due to "id" being
a keyword in the Macintosh Objective-C++ language.

Corrected error when multiple spaces between %header, %import,
%include and %declare keywords and the following name caused
an unhandled exception.

Corrected errors with % keywords and the -graph target.

(C++) The hybrid Object-C++ language has the reserved word
"id". SMC generated C++ code contains this keyword as well
as statemap.h. SMC now uses "stateId".

(Java) Corrected error in generated serialization code. The
readObject() method was not restoring the current state. The
generated Java serialization code is now completely redone and
tested.

(Java) SMC now requires that the .sm source file has the same
basename as the context class' .java source file. So if the
context class is OrderConnection and is in OrderConnection.java,
then the associated FSM must be in OrderConnection.sm.

(Ant) Corrected a syntax error in examples/Ant/EX7/build.xml.

(C++) When the .sm is in a subdirectory the slashes in the file
name are kept in the "#ifndef" in the generated header file. This
is syntactically wrong. SMC now replaces the slashes with
underscores.





                              SMC -
                  The State Machine Compiler
                        Version 3.2.0



+ Major changes
---------------

Added -graph option which generates a Graphviz/DOT representation
of the .sm finite state machine.


+ Bug fixes
-----------

Corrected errors in the example Ant build.xml files which
prevented the examples from building on Windows.

SMC is now unicode-compatible. A .sm file may contain unicode
characters but must still be a plain text file.




                              SMC -
                  The State Machine Compiler
                        Version 3.1.2



+ Major changes
---------------

No new features.


+ Bug fixes
-----------

(-csharp) Corrected an error which caused a state's entry actions
to be generated in the place of its exit actions.




                              SMC -
                  The State Machine Compiler
                        Version 3.1.1



+ Major changes
---------------

No new features.


+ Bug fixes
-----------

Fixed error when reading in .sm files larger than 4,096 bytes.
SMC reads in 4,096 bytes at a time into an internal buffer,
overwritting the buffer's previous contents.
SMC will "back up" its buffer index when it decides a character
does not belong to the current lexical token. The bug occurrs
when SMC backs up past index 0. This has been corrected by
keeping the previous buffer's last two bytes available when
reading the next 4,096 bytes (SMC backs up at most 2 bytes.)

(-c++) Removed "using namespace std" from the "-g" generated
.cpp file. All generated references to the std namespace are
now fully-qualified with "std::".

Note: This means any std namespace references in your SMC
      code must be fully-qualified as well. SMC will not
      add the "std::" scoping for you.




                              SMC -
                  The State Machine Compiler
                        Version 3.1.0



+ Major changes
---------------

Added C# target language.

Added "property = value" action to SMC syntax. This supports the
VB.net and C# property assignment syntax.

Added guards to Default transitions. However, Default transitions
still may not have parameters.

Added "-verbose" option which causes SMC to output messages as it
compiles.

Added "-d  directory" option which tells SMC where to place
generated files. Default is in the same directory as the .sm
file.


+ Bug fixes
-----------

Fixed error with TRACE macro in statemap.h.

Fixed error when compiling -c++ and .sm file is in another
directory. For example: java -jar Smc.jar -c++ src/AppClass.sm
generates an invalid AppClass_sm.h file.

Fixed error in Smc.main() which reports ParseExceptions as SMC
bugs. They are not. They are legitimate errors in the FSM code.




                              SMC -
                  The State Machine Compiler
                        Version 3.0.0



+ Major changes
---------------

Added VB.net target language.


+ Bug fixes
-----------

Fixed error where %include was flagged as wrong when -table is
set.

SMC now generates private default and copy constructors for C++.
Because the statemap::State has private default and copy
constructors, compiler-generated constructors cannot access them
which generates a warning. Having SMC declare these constructors
clears that warning.

I have made the statemap.h's debug stream code conditional.
When the SMC -g flag is set, the appropriate #define is placed
in the generated code prior to including statemap.h. This way
only debug code turns on the debug output.



                              SMC -
                  The State Machine Compiler
                        Version 2.2.0



+ Major changes
---------------

No major changes in this release.


+ Minor changes
---------------

Added the "-cast <cast_type>" command line option. Usable only
with the "-c++", it tells SMC how to downcast the current state
object to a subcalss. SMC uses dynamic_cast<> by default but
this requires runtime type information (RTTI) to be generated
by the C++ compiler. If RTTI is not generated, then
dynamic_cast<> cannot be used and either static_cast<> or
reinterpret_cast<> must be used.

Added the "-nocatch" command line option. SMC-generated code
uses a try/catch/rethrow block to protect the FSM against
application-thrown exceptions. This guarantees the FSM's state
is set before leaving the transition method. If the FSM's state
were left unset, the FSM becomes unusable.

However, certain applications cannot afford this overhead. The
"-nocatch" option prevents this try/catch/rethrow code from
being generated. Some developers thought the "-noex" option
performed this function. The "-noex" option only prevents
SMC-generated code from initiating exceptions.

Added the "-serial" command line option. This causes SMC to
associate a unique 4-byte integer ID with each state. When
storing an FSM, you need to store the current state and the
state stack (if you are using push/pop transitions). So you
store each state's unique integer ID. On restore, you use
the application context class' valueOf() method to convert
the integer ID back into a state object reference.


+ Bug fixes
-----------

SMC generated the local ctxt variable even though it was never
used. When that is the case, the ctxt variable is no longer
defined.

SMC reports an error when parsing a .sm file with a %header
construct and a -table target. The error states that %header
can only be used with a -c++ target. This is not true. It
can also be used with -table.



                              SMC -
                  The State Machine Compiler
                        Version 2.1.0



+ Major changes
---------------

Added the "-table" command line option. This tells SMC to
generate an HTML table from the .sm file. The table header is:

State     Entry             Transition
        Entry Exit  (One subheader for each)

Each cell contains each guard, end state and action for the state
and transition. Remember: each state/transition pair may have
multiple guards and each guard may have a different end state
and actions.

The generated HTML table is rudimentary since my HTML skills are
rudimentary. This feature is alpha but I hope to receive some
pointers in how I can improve the table's implementation.


+ Minor changes
---------------

I have converted all files from the DOS file format to Unix.
This caused some problems especially for gmake 3.76.1 on Sun
Solaris 8.

I have also changed the source file download to include the bin
directory as well. Now if you download the source, you also have
the Smc.jar necessary to build the product.

The Java FSMContext class no longer automatically allocates the
state stack object. The state stack is only needed if your FSM
uses the push/pop transitions. The state stack is now allocated
when it is needed. In the C++ and Tcl version, the state stack
is implemented differently and this issue does not arise.


+ Bug fixes
-----------

Removed "using namespace std" from statemap.h. Placing
"using namespace ..." in a header file is bad C++. I also use
the new <cstdio>, etc. standard header files whereever
possible instead of the older <stdio.h>.





                              SMC -
                  The State Machine Compiler
                        Version 2.0.2



+ Major changes
---------------

The SMC parser has been greatly simplified by reading in guard
conditions, transition parameter types and action arguments as
"raw" tokens rather than "cooked". "raw" means that the code
is read in verbatim from the .sm file and placed as-is into the
target source file and letting the source language compiler deal
with any errors.

SMC also has fewer classes to deal with. Instead of a separate
class for each target language (SmcMapCpp, SmcMapJava and
SmcMapTcl), there is only one class (SmcMap). SmcMap knows how
to generate code for a specific target language.



                              SMC -
                  The State Machine Compiler
                        Version 1.4.0



+ Minor changes
---------------

Placed the SMC executable JAR classes in package net.sf.smc.
NOTE: The statemap.jar package has *not* changed. The package
is still "statemap".




                              SMC -
                  The State Machine Compiler
                        Version 1.0.1


+ Bug Fixes - Default transitions
---------------------------------

Modified generated code so that all default transitions are now
defined in the <appclass>State class and not in each of the
individual map classes. The resulting generated code is
equivalent to the previous code *except* it now throws a
TransitionUndefinedException when a transition is issued in a
map which does not define that exception. Also, the generated
code has been reduced and is easier to read.

Also updated generate [incr Tcl] code so that it is now
up-to-date with the C++ and Java class structure.


+ Bug Fixes - Generated Java code thread safe
---------------------------------------------

The generated Java code is now thread safe. Now the same state
machine can be accessed from multiple threads safely.




                              SMC -
                   The State Machine Compiler
                      Version 1.0.0, Beta 4


+ Bug Fixes - Entry/Exit Actions
--------------------------------

SMC previously executed the current state's Exit actions and the
destination state's Entry actions on every transition.Experience
now shows that this is not correct behavior for loopback, push
and pop transitions. Entry and Exit actions are now executed
as follows, depending on the transition type:

+ Simple, non-loopback transition:
    1. Execute current state's Exit actions.
    2. Clear current state.
    3. Execute transition actions.
    4. Set current state to destination state.
    5. Execute destination state's Entry actions.

+ Loopback transition:
  Note: Entry and Exit actions *are* not executed.
    1. Save current state.
    2. Clear current state.
    3. Execute transition actions.
    4. Restore current state.

+ Push transition:
  Note: Only the Entry actions are executed.
    1. Push current state on top of state stack.
    2. Clear current state.
    3. Execute transition actions.
    4. Set current state to destination state.
    5. Execute destination state's Entry actions.

+ Pop transition:
  Note: Only the Exit actions are executed.
    1. Execute current state's Exit acions.
    2. Clear current state.
    3. Execute transition actions.
    4. Pop state off the top of the state stack and make it the
       current state.
    5. If the pop included a transition, issue that transition
       from the current state.




                              SMC -
                   The State Machine Compiler
                      Version 1.0, Beta 3


+ New Feature - Transition Parameters
-------------------------------------

You can now pass parameters into a transtion. You specify a
transition's parameters using the following syntax:

    OnLogin(name: const char*, passwd: const char*, grp_id: int)
    [isLoginValid(name, passwd);]
        {startLoginShell(name, passwd, grp_id);}

    OnLogin(name: const char*, passwd: const char*, grp_id: int)
    [maxLoginAttemptsReached(name);]
        {disconnect();}

    OnLogin(name: const char*, passwd: const char*, grp_id: int)
        {displayLoginPrompt();}

The format is: <transition>[(var: type[, var: type]+)]
If the transition takes no parameters, you may omit the parens
"()". Empty parens work as well.

NOTE: When a transition has multiple definitions (as in the above
example), then each transition definition *must* have exactly the
same parameter list. Transitions with the same name but different
parameter lists are *different* transitions.



+ Almost Feature - Transition Queuing
-------------------------------------

I put a "transition queuing" feature into SMC wherein, if an
object issued a transition from within a transition, the new
transition is queued until the current transition completes.

While it seemed a code idea, it spawned evil code containing
insidous bugs that are difficult to find:

+ The overarching problem is that SMC leads you to believe that a
  transition has completly executed after the transition call
  returns. With transition queuing, this is simply not true. Code
  which depends on this "transition completed upon return" will
  perform incorrectly.

+ Transition queuing + transition parameters = Big Problems.
  Passing anything other than simple, built-in types to a
  queued transition is a recipe for disastor. I couldn't figure
  out a way to deep-copy the transition's arguments (because I am
  determined that SMC be target-language neutral), so I saved
  only the argument reference. But now the application developer
  must be careful not to delete the objects until after the
  transition has been taken. This means adding transition actions
  which delete the transition's arguments plus locating the
  arguments in persistent memory. Overall, very ugly.

So, I have decided to punt on transition queuing and leave it up
to the developer to handle this problem. Objects can now query
their state machine context to see if a transition is in progress:

    bool AppClassContext::isInTransition();

If the state machine is in transition, then true is returned. The
application must not issue a transition now and should queue up
that transition for later. If isInTransition() returns false,
then a transition may be issued.

I have added a lengthy discussion to the SMC Programmer's Manual
discussing how to develop state machines which avoid this
transition-within-transition problem. In fact, I describe how to
design state machines in general.
