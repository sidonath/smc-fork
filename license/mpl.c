/*
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy
 * of the License at http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an
 * "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 * 
 * The Original Code is State Machine Compiler (SMC).
 * 
 * The Initial Developer of the Original Code is Charles W. Rapp.
 * Portions created by Charles W. Rapp are
 * Copyright (C) 2005 Charles W. Rapp.
 * All Rights Reserved.
 * 
 * Contributor(s): 
 *
 * RCS ID
 * $Id: mpl.c,v 1.5 2005/11/07 19:34:54 cwrapp Exp $
 *
 * CHANGE LOG
 * $Log: mpl.c,v $
 * Revision 1.5  2005/11/07 19:34:54  cwrapp
 * Changes in release 4.3.0:
 * New features:
 *
 * + Added -reflect option for Java, C#, VB.Net and Tcl code
 *   generation. When used, allows applications to query a state
 *   about its supported transitions. Returns a list of transition
 *   names. This feature is useful to GUI developers who want to
 *   enable/disable features based on the current state. See
 *   Programmer's Manual section 11: On Reflection for more
 *   information.
 *
 * + Updated LICENSE.txt with a missing final paragraph which allows
 *   MPL 1.1 covered code to work with the GNU GPL.
 *
 * + Added a Maven plug-in and an ant task to a new tools directory.
 *   Added Eiten Suez's SMC tutorial (in PDF) to a new docs
 *   directory.
 *
 * Fixed the following bugs:
 *
 * + (GraphViz) DOT file generation did not properly escape
 *   double quotes appearing in transition guards. This has been
 *   corrected.
 *
 * + A note: the SMC FAQ incorrectly stated that C/C++ generated
 *   code is thread safe. This is wrong. C/C++ generated is
 *   certainly *not* thread safe. Multi-threaded C/C++ applications
 *   are required to synchronize access to the FSM to allow for
 *   correct performance.
 *
 * + (Java) The generated getState() method is now public.
 *
 * Revision 1.4  2005/05/28 18:49:30  cwrapp
 * Updated license comments.
 *
 * Revision 1.0  2003/12/14 21:08:31  charlesr
 * Initial revision
 *
 */
