#!/bin/sh
# -*- tab-width: 4; -*-
# \
exec wish -f "$0" "$@"

# 
# The contents of this file are subject to the Mozilla Public
# License Version 1.1 (the "License"); you may not use this file
# except in compliance with the License. You may obtain a copy of
# the License at http://www.mozilla.org/MPL/
# 
# Software distributed under the License is distributed on an "AS
# IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
# implied. See the License for the specific language governing
# rights and limitations under the License.
# 
# The Original Code is State Machine Compiler (SMC).
# 
# The Initial Developer of the Original Code is Charles W. Rapp.
# Portions created by Charles W. Rapp are
# Copyright (C) 2000 - 2003 Charles W. Rapp.
# All Rights Reserved.
# 
# Contributor(s):
#
# RCS ID
# $Id: TASKMAN.TCL,v 1.8 2009/03/27 09:41:47 cwrapp Exp $
#
# CHANGE LOG
# $Log: TASKMAN.TCL,v $
# Revision 1.8  2009/03/27 09:41:47  cwrapp
# Added F. Perrad changes back in.
#
# Revision 1.7  2008/02/04 12:39:02  fperrad
# fix filename case on linux
#
# Revision 1.6  2005/06/08 11:09:14  cwrapp
# + Updated Python code generator to place "pass" in methods with empty
#   bodies.
# + Corrected FSM errors in Python example 7.
# + Removed unnecessary includes from C++ examples.
# + Corrected errors in top-level makefile's distribution build.
#
# Revision 1.5  2005/05/28 18:02:56  cwrapp
# Updated Tcl examples, removed EX6.
#
# Revision 1.1  2005/01/22 13:19:59  charlesr
# Added statemap package location to auto_path.
#
# Revision 1.0  2003/12/14 20:32:13  charlesr
# Initial revision
#

#############################################################################
# Visual Tcl v1.20 Project
#

#################################
# GLOBAL VARIABLES
#
global MessageLevel; 
global widget; 

set widget(CreateTaskButton) {.top17.but29}
set widget(MessageCanvas) {.top17.can17}
set widget(MessageLevelScale) {.top17.sca32}
set widget(MessageXScrollbar) {.top17.scr22}
set widget(MessageYScrollbar) {.top17.scr23}
set widget(QuitButton) {.top17.but30}
set widget(TaskCanvas) {.top17.can19}
set widget(TaskManagerFrame) {.top17}
set widget(TaskYScrollbar) {.top17.scr18}
set widget(rev,.top17) {TaskManagerFrame}
set widget(rev,.top17.but29) {CreateTaskButton}
set widget(rev,.top17.but30) {QuitButton}
set widget(rev,.top17.can17) {MessageCanvas}
set widget(rev,.top17.can19) {TaskCanvas}
set widget(rev,.top17.sca32) {MessageLevelScale}
set widget(rev,.top17.scr18) {TaskYScrollbar}
set widget(rev,.top17.scr22) {MessageXScrollbar}
set widget(rev,.top17.scr23) {MessageYScrollbar}

lappend auto_path ../../../lib/Tcl

#################################
# USER DEFINED PROCEDURES
#
proc init {argc argv} {
    global widget;

    # Load in the necessary Tcl packages.
    package require Itcl;
    package require statemap;

    namespace import ::itcl::*;
    namespace import ::statemap::*;

    # Load in the class definitions.
    source ./TASK.TCL;
    source ./taskManager.tcl;
    source ./taskGUI.tcl;
    source ./messageGUI.tcl;
    source ./statusGUI.tcl;
    source ./taskDialog.tcl;

    return -code ok;
}

init $argc $argv


proc {main} {argc argv} {
    global widget;

    # Create the task pop-up menu. This menu will be displayed
    # when the user clicks on a task.
    set TaskMenu [menu $widget(TaskCanvas).taskMenu -tearoff 0 -type normal];
    $TaskMenu add command -label "Block"  -state normal;
    $TaskMenu add command -label "Unblock"  -state normal;
    $TaskMenu add command -label "Delete"  -state normal;

    # Put this pop-up menu and its entries into the widget table.
    set widget(TaskMenu) $TaskMenu;
    set widget(rev,$TaskMenu) TaskMenu;
    set widget(BlockMenuEntry) 0;
    set widget(rev,0) BlockMenuEntry;
    set widget(UnblockMenuEntry) 1;
    set widget(rev,1) UnblockMenuEntry;
    set widget(DeleteMenuEntry) 2;
    set widget(rev,2) DeleteMenuEntry;

    # Create the GUI Controller. This object is the gateway
    # between the GUI objects and the model objects.
    GUIController guiController;

    # GUI objects.
    MessageGUI messageGUI $widget(MessageCanvas) 3;
    StatusGUI statusGUI $widget(TaskCanvas);
    TaskCreateDialog taskCreateDialog;

    # Set the message filter scale's value.
    $widget(MessageLevelScale) set [messageGUI getLevel];

    TaskManager taskManager;
}

proc {Window} {args} {
    global vTcl

    set cmd [lindex $args 0]
    set name [lindex $args 1]
    set newname [lindex $args 2]
    set rest [lrange $args 3 end]
    if {$name == "" || $cmd == ""} {return}
    if {$newname == ""} {
        set newname $name
    }
    set exists [winfo exists $newname]
    switch $cmd {
        show {
            if {$exists == "1" && $name != "."} {wm deiconify $name; return}
            if {[info procs vTclWindow(pre)$name] != ""} {
                eval "vTclWindow(pre)$name $newname $rest"
            }
            if {[info procs vTclWindow$name] != ""} {
                eval "vTclWindow$name $newname $rest"
            }
            if {[info procs vTclWindow(post)$name] != ""} {
                eval "vTclWindow(post)$name $newname $rest"
            }
        }
        hide    { if $exists {wm withdraw $newname; return} }
        iconify { if $exists {wm iconify $newname; return} }
        destroy { if $exists {destroy $newname; return} }
    }
}

#################################
# VTCL GENERATED GUI PROCEDURES
#

proc vTclWindow. {base} {
    if {$base == ""} {
        set base .
    }
    ###################
    # CREATING WIDGETS
    ###################
    wm focusmodel $base passive
    wm geometry $base 200x200+0+0
    wm maxsize $base 1284 1009
    wm minsize $base 104 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm withdraw $base
    wm title $base "vt"
    ###################
    # SETTING GEOMETRY
    ###################
}

proc vTclWindow.top17 {base} {
    if {$base == ""} {
        set base .top17
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }
    ###################
    # CREATING WIDGETS
    ###################
    toplevel $base -class Toplevel \
        -height 975 -menu .top17.m31 -width 1284 
    wm focusmodel $base passive
    wm geometry $base 571x508+336+221
    wm maxsize $base 1284 1009
    wm minsize $base 104 1
    wm overrideredirect $base 0
    wm resizable $base 1 1
    wm deiconify $base
    wm title $base "Task Manager"
    label $base.lab18 \
        -borderwidth 1 -text {Task List} 
    canvas $base.can19 \
        -background #ffffff -borderwidth 2 -height 189 -relief ridge \
        -scrollregion {0 0 559 500} -width 559 \
        -yscrollcommand {global widget; $widget(TaskYScrollbar) set} 
    label $base.lab22 \
        -borderwidth 1 -font {{MS Sans Serif} 8 bold} -relief groove \
        -text Name 
    label $base.lab23 \
        -borderwidth 1 -font {{MS Sans Serif} 8 bold} -relief sunken \
        -text Priority 
    label $base.lab24 \
        -borderwidth 1 -font {{MS Sans Serif} 8 bold} -relief sunken \
        -text State 
    label $base.lab25 \
        -borderwidth 1 -font {{MS Sans Serif} 8 bold} -relief sunken \
        -text Completion 
    label $base.lab26 \
        -borderwidth 1 -text Messages 
    button $base.but29 \
        -command {taskCreateDialog display;} -text {Create Task ...} 
    button $base.but30 \
        -command {guiController postMessage taskManager shutdown;} -text Quit 
    menu $base.m31 \
        -cursor {} 
    canvas $base.can17 \
        -background white -borderwidth 2 -height 160 -relief ridge \
        -scrollregion {0 0 1000 2000} -width 536 \
        -xscrollcommand {global widget; $widget(MessageXScrollbar) set} \
        -yscrollcommand {global widget; $widget(MessageYScrollbar) set} \
        -yscrollincrement 17 
    label $base.lab27 \
        -borderwidth 1 -font {{MS Sans Serif} 8 bold} -relief sunken \
        -text Date 
    label $base.lab28 \
        -borderwidth 1 -font {{MS Sans Serif} 8 bold} -relief sunken \
        -text Time 
    label $base.lab29 \
        -borderwidth 1 -font {{MS Sans Serif} 8 bold} -relief sunken \
        -text Object 
    label $base.lab30 \
        -borderwidth 1 -font {{MS Sans Serif} 8 bold} -relief sunken \
        -text Message 
    label $base.lab31 \
        -borderwidth 1 -font {{MS Sans Serif} 8 bold} -relief sunken \
        -text Level 
    scale $base.sca32 \
        -command {guiController setLevel} -orient horizontal \
        -to 10.0 -variable ::MessageLevel 
    label $base.lab33 \
        -borderwidth 1 -font {{MS Sans Serif} 8 bold} -text {Message Level:} 
    label $base.lab17 \
        -borderwidth 1 -font {{MS Sans Serif} 8 bold} -relief sunken \
        -text Time 
    scrollbar $base.scr18 \
        -command {global widget; $widget(TaskCanvas) yview} 
    scrollbar $base.scr22 \
        -command {global widget; $widget(MessageCanvas) xview} \
        -orient horizontal 
    scrollbar $base.scr23 \
        -command {global widget; $widget(MessageCanvas) yview} 
    ###################
    # SETTING GEOMETRY
    ###################
    place $base.lab18 \
        -x 10 -y 5 -width 559 -height 20 -anchor nw -bordermode ignore 
    place $base.can19 \
        -x 10 -y 50 -width 535 -height 134 -anchor nw -bordermode ignore 
    place $base.lab22 \
        -x 15 -y 30 -width 179 -height 20 -anchor nw -bordermode ignore 
    place $base.lab23 \
        -x 285 -y 30 -width 59 -height 20 -anchor nw -bordermode ignore 
    place $base.lab24 \
        -x 195 -y 30 -width 89 -height 20 -anchor nw -bordermode ignore 
    place $base.lab25 \
        -x 405 -y 30 -width 134 -height 20 -anchor nw -bordermode ignore 
    place $base.lab26 \
        -x 5 -y 190 -width 559 -height 20 -anchor nw -bordermode ignore 
    place $base.but29 \
        -x 160 -y 465 -width 106 -height 31 -anchor nw -bordermode ignore 
    place $base.but30 \
        -x 300 -y 465 -width 106 -height 31 -anchor nw -bordermode ignore 
    place $base.can17 \
        -x 10 -y 235 -width 536 -height 160 -anchor nw -bordermode ignore 
    place $base.lab27 \
        -x 15 -y 215 -width 74 -height 20 -anchor nw -bordermode ignore 
    place $base.lab28 \
        -x 90 -y 215 -width 54 -height 20 -anchor nw -bordermode ignore 
    place $base.lab29 \
        -x 140 -y 215 -width 99 -height 20 -anchor nw -bordermode ignore 
    place $base.lab30 \
        -x 285 -y 215 -width 259 -height 20 -anchor nw -bordermode ignore 
    place $base.lab31 \
        -x 240 -y 215 -width 44 -height 20 -anchor nw -bordermode ignore 
    place $base.sca32 \
        -x 130 -y 405 -width 163 -height 47 -anchor nw -bordermode ignore 
    place $base.lab33 \
        -x 20 -y 425 -width 114 -height 20 -anchor nw -bordermode ignore 
    place $base.lab17 \
        -x 345 -y 30 -width 59 -height 20 -anchor nw -bordermode ignore 
    place $base.scr18 \
        -x 545 -y 50 -width 13 -height 134 -anchor nw -bordermode ignore 
    place $base.scr22 \
        -x 10 -y 395 -width 534 -height 13 -anchor nw -bordermode ignore 
    place $base.scr23 \
        -x 545 -y 235 -width 13 -height 159 -anchor nw -bordermode ignore 
}

Window show .
Window show .top17

main $argc $argv
