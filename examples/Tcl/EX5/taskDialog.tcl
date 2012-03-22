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
# TaskDialog --
#
#  Displays the task dialog box and collects the task parameters.
#  On OK, sends a createTask message to the GUI controller.
#
# RCS ID
# $Id: taskDialog.tcl,v 1.6 2005/06/08 11:09:14 cwrapp Exp $
#
# CHANGE LOG
# $Log: taskDialog.tcl,v $
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
# Revision 1.0  2003/12/14 20:34:40  charlesr
# Initial revision
#

class TaskCreateDialog {

# Member data.
    # Store the top frame widget here.
    private variable _topFrame;

    # Store the top frame's geometry here.
    private variable _geometry;

    # While the task dialog is being filled in,
    # store the task parameters here.
    private variable _name;
    private variable _priority;
    private variable _time;

# Member functions.
    # constructor --
    #
    #   Create the task dialog box and hide it.
    #
    # Arguments:
    #   top   The top frame containing the dialog widget.
    #
    # Results:
    #   None.

    constructor {} {
        ResetParameters;

        # Create the dialog GUI.
        set _topFrame [CreateDialog];
        set _geometry "";
    }

    destructor {}

    # setName --
    #
    #   Store away the task's name.
    #
    # Arguments:
    #   name   The task name.
    #
    # Results:
    #   None.

    public method setName {name} {
        set _name $name;
        return -code ok;
    }

    # setPriority --
    #
    #   Store away the task's priority.
    #
    # Arguments:
    #   priority   The task priority.
    #
    # Results:
    #   None.

    public method setPriority {priority} {
        set _priority $priority;
        return -code ok;
    }

    # setTime --
    #
    #   Store away the task's time.
    #
    # Arguments:
    #   time   The task time.
    #
    # Results:
    #   None.

    public method setTime {time} {
        set _time $time;
        return -code ok;
    }

    # display --
    #
    #   Display the CreateTask dialog. Check if the window
    #   already exists. If it does, unhide it and bring it
    #   to the foreground. If not, then create the window.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    public method display {} {
        global widget Gwait_for_it;

        # If the dialog does not exist, then create it.
        # Otherwise, bring it out of hiding.
        if {[string length $_topFrame] == 0} {
            set _topFrame [CreateDialog];
        } else {
            wm deiconify $_topFrame;
        }

        if {[string length $_geometry] > 0} {
            catch {wm geometry $_topFrame $_geometry};
        }

        # Focus on the dialog's name entry field.
        set OldFocus [focus -displayof $_topFrame];
        focus $_topFrame.nameEntry;
        catch {tkwait visibility $_topFrame};
        catch {grab $_topFrame};

        # Wait for the dialog to complete. When done, reset the
        # focus to where it had been.
        set Gwait_for_it false;
        tkwait variable Gwait_for_it;
        catch {grab release $_topFrame};
        focus $OldFocus;

        # Check the dialog's completion. If true, then
        # the user set the variables and is trying to
        # create a task.
        if {[string compare $Gwait_for_it "true"] == 0} {
            guiController postMessage \
                    taskManager createTask $_name $_priority $_time;
        }

        # Reset the parameters because whether the task creation
        # was successful or not, they are no longer needed.
        ResetParameters;

        # If possible, save the dialog's current size and
        # position.
        if {[catch {set _geometry [wm geometry $_topFrame]; wm withdraw $_topFrame;}] != 0} {
            # The dialog box was destroyed. Create it again
            # the next time it is needed.
            set _topFrame "";
            set _geometry "";
        } else {
            $_topFrame.nameEntry delete 0 end;
            $_topFrame.priorityScale set $_priority;
            $_topFrame.timeScale set $_time;
        }

        return -code ok;
    }

    # ResetParameters --
    #
    #   Reset the task creation parameters to their uninitialized
    #   values.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    private method ResetParameters {} {
        set _name "";
        set _priority 0;
        set _time 0;

        return -code ok;

    }

    # CreateDialog --
    #
    #   Create the dialog box but keep it hidden.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   The name of the top frame.

    private method CreateDialog {} {
        set base .createTaskDialog;

        toplevel $base -class Toplevel -relief raised;
        wm withdraw $base;
        wm focusmodel $base passive;
        wm geometry $base 256x193+451+410;
        wm maxsize $base 1284 1009;
        wm minsize $base 104 1;
        wm overrideredirect $base 0;
        wm resizable $base 0 0;
        wm title $base "Create Task";

        # Handle Control-C and destroy events.
        bind $base <Control-Key-c> {
            global Gwait_for_it;
            set Gwait_for_it false;
            break;
        }
        bind $base <Destroy> {
            global Gwait_for_it;
            set Gwait_for_it false;
        }

        # Add the dialog widgets.
        label $base.nameLabel \
                -borderwidth 1 \
                -justify left \
                -text Name;
        entry $base.nameEntry \
                -textvariable ::TaskName;
        label $base.priorityLabel \
                -borderwidth 1 \
                -justify left \
                -text Priority;
        scale $base.priorityScale \
                -from 1.0 \
                -orient horizontal \
                -tickinterval 1.0 \
                -to 10.0 \
                -variable ::TaskPriority;
        label $base.timeLabel \
                -borderwidth 1 \
                -justify left \
                -text Time;
        scale $base.timeScale \
                -from 1.0 \
                -orient horizontal \
                -tickinterval 5.0 \
                -to 60.0 \
                -variable ::TaskTime;
        button $base.okButton \
                -command { \
                    global Gwait_for_it; \
                    taskCreateDialog setName ${::TaskName}; \
                    taskCreateDialog setPriority ${::TaskPriority}; \
                    taskCreateDialog setTime ${::TaskTime}; \
                    set Gwait_for_it true; \
                } \
                -text OK;
        button $base.cancelButton \
                -command { \
                    global Gwait_for_it; \
                    set Gwait_for_it false; \
                } \
                -text Cancel;

        ###################
        # SETTING GEOMETRY
        ###################
        place $base.nameLabel \
                -x 15 \
                -y 20 \
                -width 39 \
                -height 20 \
                -anchor nw \
                -bordermode ignore;
        place $base.nameEntry \
                -x 60 \
                -y 20 \
                -width 186 \
                -height 22 \
                -anchor nw \
                -bordermode ignore;
        place $base.priorityLabel \
                -x 5 \
                -y 60 \
                -width 54 \
                -height 20 \
                -anchor nw \
                -bordermode ignore;
        place $base.priorityScale \
                -x 55 \
                -y 40 \
                -width 193 \
                -height 47 \
                -anchor nw \
                -bordermode ignore;
        place $base.timeLabel \
                -x 20 \
                -y 110 \
                -anchor nw \
                -bordermode ignore;
        place $base.timeScale \
                -x 55 \
                -y 90 \
                -width 193 \
                -height 47 \
                -anchor nw \
                -bordermode ignore;
        place $base.okButton \
                -x 80 \
                -y 150 \
                -width 58 \
                -height 31 \
                -anchor nw \
                -bordermode ignore;
        place $base.cancelButton \
                -x 150 \
                -y 150 \
                -anchor nw \
                -bordermode ignore;

        return -code ok $base;
    }
}
