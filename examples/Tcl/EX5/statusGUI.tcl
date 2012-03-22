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
# StatusGUI --
#
#   For each existing tasks, display the task name, priority,
#   total time and percent completion (as a scale).
#
# RCS ID
# $Id: statusGUI.tcl,v 1.4 2005/05/28 18:02:56 cwrapp Exp $
#
# CHANGE LOG
# $Log: statusGUI.tcl,v $
# Revision 1.4  2005/05/28 18:02:56  cwrapp
# Updated Tcl examples, removed EX6.
#
# Revision 1.0  2003/12/14 20:32:48  charlesr
# Initial revision
#

class StatusGUI {

# Member data.
    # Put the information on this canvas.
    private variable _canvas;

    # This array contains all the currently displayed tasks.
    private variable _taskTable;

    # This array associates task names with rows.
    private variable _displayTable;

    # There static variables store the display field
    # widths and each row's height. They are needed to
    # calculate coordinates. All values specified in pixels.
    private common _initialXOffset 8;
    private common _initialYOffset 8;
    private common _rowHeight 15;
    private common _rowSeparation 4;
    private common _rowPaddedHeight [expr $_rowHeight + $_rowSeparation];
    private common _colSeparation 4;
    private common _nameWidth 180;
    private common _nameJustify left;
    private common _nameX1 $_initialXOffset;
    private common _nameX2 [expr $_nameX1 + $_nameWidth];
    private common _stateWidth 100;
    private common _stateJustify left;
    private common _stateX1 [expr $_nameX2 + $_colSeparation];
    private common _stateX2 [expr $_stateX1 + $_stateWidth];
    private common _priorityWidth 50;
    private common _priorityJustify right;
    private common _priorityX1 [expr $_stateX2 + $_colSeparation];
    private common _priorityX2 [expr $_priorityX1 + $_priorityWidth];
    private common _timeWidth 50;
    private common _timeJustify right;
    private common _timeX1 [expr $_priorityX2 + $_colSeparation];
    private common _timeX2 [expr $_timeX1 + $_timeWidth];
    private common _rectSeparation 2;
    private common _rect1Width 100;
    private common _rect1X1 [expr $_timeX2 + $_colSeparation];
    private common _rect1X2 [expr $_rect1X1 + $_rect1Width];
    private common _rect2Width [expr $_rect1Width - \
                                   [expr $_rectSeparation * 2]];
    private common _rect2X1 [expr $_rect1X1 + $_rectSeparation];
    private common _percentX1 [expr $_rect1X1 + [expr $_rect1Width / 2]];
    private common _X1 $_initialXOffset;
    private common _X2 $_rect1X2;

# Member methods.
    constructor {canvas} {
        set _canvas $canvas;
    }

    destructor {};

    # taskCreated --
    #
    #   Place a new task on the display.
    #
    # Arguments:
    #   name      Task's print name (not object name).
    #   state     Task's current state.
    #   priority  Task's static priority
    #   time      Task's total run time.
    #
    # Results:
    #   None.

    public method taskCreated {name state priority time} {
        global widget;

        # Put this information into the task array.
        set TaskInfo(name) $name;
        set TaskInfo(state) $state;
        set TaskInfo(priority) $priority;
        set TaskInfo(time) $time;
        set TaskInfo(timeLeft) [expr $time * 1000];
        set TaskInfo(percentComplete) 0;

        # Create the entry widget which contains the task name.
        set TaskInfo(nameEntry) \
                [entry $widget(TaskCanvas).entry$name \
                    -relief flat \
                    -borderwidth 0 \
                    -justify $_nameJustify \
                    -background [$_canvas cget -background]];

        # Put the task name into the widget.
        $TaskInfo(nameEntry) \
                insert 0 $name;

        # Make the entry widget read only.
        $TaskInfo(nameEntry) configure \
                -state disabled;

        # bind $TaskInfo(nameEntry) \
        #        <ButtonPress-1> \
        #        [list $this displayTaskMenu $name %W %x %y];

        # Set the canvas IDs to empty strings since this
        # task is not yet displayed.
        set TaskInfo(nameID) -1;
        set TaskInfo(stateID) -1;
        set TaskInfo(priorityID) -1;
        set TaskInfo(timeID) -1;
        set TaskInfo(rect1ID) -1;
        set TaskInfo(rect2ID) -1;
        set TaskInfo(percentID) -1;

        # Have the display method figure out where the task
        # goes on the display.
        set RowCount [array size _taskTable];
        set TaskInfo(row) $RowCount;
        
        # Store the task in the task table.
        set _taskTable($name) [array get TaskInfo];
        set _displayTable($TaskInfo(row)) $name;

        DisplayTask $name new;

        return -code ok;
    }

    # taskStateUpdate --
    #
    #   Update the specified task's state.
    #
    # Arguments:
    #   name      Task's print name (not object name).
    #   state     Task's current state.
    #
    # Results:
    #   None.

    public method taskStateUpdate {name state} {
        # Is this task already being displayed.
        if {[string length [array names _taskTable $name]] > 0} {
            # Yes, it does exist. Update the display but only
            # if different. Note: the task priority and time do
            # not change, only state and percent complete do.
            array set TaskInfo $_taskTable($name);
            if {[string compare $TaskInfo(state) $state] != 0} {
                set TaskInfo(state) $state;
                set _taskTable($name) [array get TaskInfo];

                # Update the task's display.
                DisplayTask $name state;

                # If the task has completed (Done state) or been
                # deleted, then set up a timer to remove the task
                # from the display.
                if {[string compare $state "Done"] == 0 || \
                    [string compare $state "Deleted"] == 0} {
                    after 1500 [list $this removeTask $name];
                }
            }
        }

        return -code ok;
    }

    # taskTimeUpdate --
    #
    #   Update the specified task's percent complete.
    #
    # Arguments:
    #   name      Task's print name (not object name).
    #   timeLeft  Task's time remaining to run.
    #
    # Results:
    #   None.

    public method taskTimeUpdate {name timeLeft} {
        # Is this task already being displayed.
        if {[string length [array names _taskTable $name]] > 0} {
            # Yes, it does exist. Update the display but only
            # if different.
            array set TaskInfo $_taskTable($name);
            set TotalTime [expr $TaskInfo(time) * 1000.0];
            set NewPercentComplete \
                    [expr [expr [expr $TotalTime - $timeLeft] / \
                                $TotalTime] * \
                          100.0];
            if {$TaskInfo(percentComplete) != $NewPercentComplete} {
                set TaskInfo(percentComplete) $NewPercentComplete;                        
                set _taskTable($name) [array get TaskInfo];

                # Update the task's display.
                DisplayTask $name time;
            }
        }

        return -code ok;
    }

    # removeTask --
    #
    #   Remove the task from the display. Simply delete the
    #   canvas objects associated with the task. If the task
    #   is the last row, then do nothing more. If not, then
    #   move all the rows below the task up one row.
    #
    # Arguments:
    #   name   The task's name.
    #
    # Results:
    #   None.

    public method removeTask {name} {
        # Is this a known task?
        if {[string length [array names _taskTable $name]] != 0} {
            DisplayTask $name remove;

            array set TaskInfo $_taskTable($name);

            # First, get the current table size and then remove
            # the task from the table.
            set LastRow [expr [array size _taskTable] - 1];
            unset _taskTable($name);
            unset _displayTable($TaskInfo(row));

            # Delete the task name's entry widget.
            destroy $TaskInfo(nameEntry);

            # Before deleting the task from the table,
            # figure out where it was in the display.
            if {$TaskInfo(row) < $LastRow} {
                # Since the display table will be updated by
                # the move up process, make a list of tasks
                # to be updated first.
                set TaskList {};
                for {set i [expr $TaskInfo(row) + 1]} {$i <= $LastRow} {incr i} {
                    lappend TaskList $_displayTable($i);
                }

                foreach Task $TaskList {
                    DisplayTask $Task moveup;
                }
            }
        }
    }

    # displayTaskMenu --
    #
    #   Put up the task pop-up menu at the specified coordinates.
    #   The menu consists of three items: Block, Unblock and
    #   Delete. If the task in not in the blocked state, then
    #   the Unblock item is disabled. If the task is in the
    #   blocked state, then Block is disabled. A task can
    #   always be deleted.
    #
    # Arguments:
    #   name   The task's name.
    #   window The window reporting the click.
    #   x      The menu's upper left x coordinate.
    #   y      The menu's upper left y coordinate.
    #
    # Results:
    #   None.

    public method displayTaskMenu {name window x y} {
        if {[string length [array names _taskTable $name]] != 0} {
            global widget;

            array set TaskInfo $_taskTable($name);

            # Figure out whether Blocked and Unblocked are normal
            # or disabled. Also, configure the entry commands
            # since the commands need to access the task name.
            if {[string compare $TaskInfo(state) "Blocked"] == 0} {
                $widget(TaskMenu) entryconfigure \
                        $widget(BlockMenuEntry) \
                        -state disabled \
                        -command "";
                $widget(TaskMenu) entryconfigure \
                        $widget(UnblockMenuEntry) \
                        -state normal \
                        -command [list guiController postMessage \
                                       taskManager unblockTask $name];
            } else {
                $widget(TaskMenu) entryconfigure \
                        $widget(BlockMenuEntry) \
                        -state normal \
                        -command [list guiController postMessage \
                                       taskManager blockTask $name];
                $widget(TaskMenu) entryconfigure \
                        $widget(UnblockMenuEntry) \
                        -state disabled \
                        -command "";
            }

            $widget(TaskMenu) entryconfigure \
                    $widget(DeleteMenuEntry) \
                    -command [list guiController postMessage \
                                   taskManager deleteTask $name];

            # The coordinates are in relation to the task row.
            # But tk_popup uses screen coordinates. Convert 
            # So add the row's X1 and Y1 to the coordinates.
            $widget(TaskMenu) post \
                    [expr [winfo rootx $window] + $x] \
                    [expr [winfo rooty $window] + $y];
        }

        return -code ok;
    }

    # DisplayTask --
    #
    #   Update a task's display. If the task is new, then
    #   put the entire task on the canvas. If just one part
    #   of the task is being updated, then update just that
    #   part.
    #
    # Arguments:
    #   name         The task's name.
    #   updateType   new, state, time, moveup or remove. If new,
    #                then put the task on the display. If status,
    #                then update the status field. If time, then
    #                update the complete slider and time left
    #                fields. If moveup, then move the row up one.
    #                If remove, then remove the task's display.
    #
    # Results:
    #   None.

    private method DisplayTask {name updateType} {
        # Is this a known task?
        if {[string length [array names _taskTable $name]] != 0} {
            switch -exact -- $updateType {
                new {
                    # Figure out where the task goes on the
                    # canvas. Each row is 15 pixels high and
                    # there are 4 pixels between rows. First,
                    # figure out how many rows are displayed.
                    # The rows upper Y coordinate is 19n + the
                    # initial offset from the canvas edge. The
                    # lower Y coordinate is the upper Y coordinate
                    # plus the row height. The X coordinates are
                    # fixed. Rows are number starting at 0.
                    array set TaskInfo $_taskTable($name);

                    set TaskInfo(Y1) \
                            [expr [expr $TaskInfo(row) * \
                                        $_rowPaddedHeight] + \
                                  $_initialYOffset];
                    set TaskInfo(Y2) [expr $TaskInfo(Y1) + $_rowHeight];

                    # Put the updated task info back into the
                    # task table.
                    set _taskTable($name) [array get TaskInfo];

                    # Now display the entire row.
                    DisplayTaskInfo $name [list name state priority time percentComplete];
                }

                state {
                    DisplayTaskInfo $name [list state];
                }

                time {
                    DisplayTaskInfo $name [list percentComplete];
                }

                moveup {
                    # First, remove the task from the display.
                    RemoveTaskInfo $name;

                    array set TaskInfo $_taskTable($name);

                    # Update the task's row number and
                    # {X1, Y1} coordinates.
                    unset _displayTable($TaskInfo(row));
                    incr TaskInfo(row) -1;

                    set TaskInfo(Y1) \
                            [expr [expr $TaskInfo(row) * \
                                        $_rowPaddedHeight] + \
                                  $_initialYOffset];
                    set TaskInfo(Y2) [expr $TaskInfo(Y1) + $_rowHeight];
                    set _displayTable($TaskInfo(row)) $name;

                    # Put the update task information back into
                    # the task table
                    set _taskTable($name) [array get TaskInfo];

                    # Now put the task back on display.
                    DisplayTaskInfo $name [list name state priority time percentComplete];
                }

                remove {
                    RemoveTaskInfo $name;
                }
            }
        }
        # Else an unknown task was specified. Ignore request.

        return -code ok;
    }

    # DisplayTaskInfo --
    #
    #   Display the specified task info on the canvas.
    #
    # Arguments:
    #   name      The task's name.
    #   infoList  The task information to be displayed.
    #
    # Results:
    #   None.

    private method DisplayTaskInfo {name infoList} {
        global widget;

        # Is this a known task?
        if {[string length [array names _taskTable $name]] != 0} {
            # Get the task info.
            array set TaskInfo $_taskTable($name);

            foreach InfoName $infoList {
                switch -exact -- $InfoName {
                    name {
                        # Since task names can be very long. Use
                        # the entry widget to display them.
                        if {$TaskInfo(nameID) < 0} {
                            set TaskInfo(nameID) \
                                    [$_canvas create window \
                                        $_nameX1 \
                                        $TaskInfo(Y1) \
                                        -height $_rowHeight \
                                        -width $_nameWidth \
                                        -anchor nw \
                                        -window $TaskInfo(nameEntry)];

                            # Put the update task information
                            # back into the task table.
                            set _taskTable($name) [array get TaskInfo];
                        }
                        # The task name should never be updated.
                        # If the name is already displayed, then
                        # do nothing.
                    }

                    state -
                    priority -
                    time {
                        # These are text fields and use the same
                        # display code.
                        # If the text is already displayed, remove it.
                        set FieldName ${InfoName}ID;
                        if {$TaskInfo($FieldName) < 0} {
                            set X1VarName "_${InfoName}X1";
                            set JustifyVarName "_${InfoName}Justify";
                            set TaskInfo($FieldName) \
                                    [$_canvas create text \
                                              [eval "set $X1VarName"] \
                                              $TaskInfo(Y1) \
                                              -text $TaskInfo($InfoName) \
                                              -anchor nw \
                                              -justify [eval "set $JustifyVarName"]];


                            $_canvas bind $TaskInfo($FieldName) \
                                    <ButtonPress-1> \
                                    [list $this displayTaskMenu $name %W %x %y];

                            # Put the update task information
                            # back into the task table.
                            set _taskTable($name) [array get TaskInfo];
                        } else {
                            $_canvas itemconfigure \
                                    $TaskInfo($FieldName) \
                                    -text $TaskInfo($InfoName);
                        }
                    }

                    percentComplete {
                        # This display uses rectangles and text.
                        if {$TaskInfo(rect1ID) < 0} {
                            # Draw the background grey rectangle.
                            set TaskInfo(rect1ID) \
                                    [$_canvas create rect \
                                        $_rect1X1 \
                                        $TaskInfo(Y1) \
                                        $_rect1X2 \
                                        $TaskInfo(Y2) \
                                        -fill grey \
                                        -width 2];

                            $_canvas bind $TaskInfo(rect1ID) \
                                    <ButtonPress-1> \
                                    [list $this displayTaskMenu $name %W %x %y];

                            # Put the update task information
                            # back into the task table.
                            set _taskTable($name) [array get TaskInfo];
                        }

                        # Draw the blue bar only if the percent
                        # complete is greater than 0.
                        if {$TaskInfo(percentComplete) > 0} {
                            # Figure out how the blue rectangle's
                            # coordinates based on percent completion.
                            # Remember: the inside rectangle's
                            # length is smaller than the grey
                            # rectangle's.
                            set Rect2X2 [expr $_rect1X1 + \
                                    [expr $_rect2Width * \
                                        [expr $TaskInfo(percentComplete) / 100.0]]];
                            set Rect2Y1 [expr $TaskInfo(Y1) + $_rectSeparation];
                            set Rect2Y2 [expr $TaskInfo(Y2) - $_rectSeparation];

                            # The only way to update the blue rectangle
                            # is to delete it and redraw it. Also
                            # delete the percent text as well.
                            if {$TaskInfo(percentID) >= 0} {
                                $_canvas delete $TaskInfo(percentID);
                                set TaskInfo(percentID) -1;
                            }

                            if {$TaskInfo(rect2ID) >= 0} {
                                $_canvas delete $TaskInfo(rect2ID);
                                set TaskInfo(rect2ID) -1;
                            }

                            # Now draw the blue rectangle.
                            set TaskInfo(rect2ID) \
                                    [$_canvas create rect \
                                        $_rect2X1 \
                                        $Rect2Y1 \
                                        $Rect2X2 \
                                        $Rect2Y2 \
                                        -fill blue \
                                        -outline ""];

                            $_canvas bind $TaskInfo(rect2ID) \
                                    <ButtonPress-1> \
                                    [list $this displayTaskMenu $name %W %x %y];
                        }

                        # Always draw the % complete text.
                        # But first change it from a float to
                        # an integer.
                        if {$TaskInfo(percentID) < 0} {
                            set TaskInfo(percentID) \
                                    [$_canvas create text \
                                        $_percentX1 \
                                        $TaskInfo(Y1) \
                                        -text "[expr int($TaskInfo(percentComplete))]%" \
                                        -fill white \
                                        -anchor nw];

                            $_canvas bind $TaskInfo(percentID) \
                                    <ButtonPress-1> \
                                    [list $this displayTaskMenu $name %W %x %y];
                        } else {
                            $_canvas itemconfigure $TaskInfo(percentID) \
                                    -text "[expr int($TaskInfo(percentComplete))]%";
                        }

                        # Put the update task information
                        # back into the task table.
                        set _taskTable($name) [array get TaskInfo];
                    }
                }
            }
        }
        # Else this task is unknown. Ignore request.

        return -code ok;
    }

    # RemoveTaskInfo --
    #
    #   Remove the task's row from the display.
    #
    # Arguments:
    #   name   The task's name.
    #
    # Results:
    #   None.

    private method RemoveTaskInfo {name} {
        # Is this a known task?
        if {[string length [array names _taskTable $name]] != 0} {
            # Yes. Get the task information.
            array set TaskInfo $_taskTable($name);

            if {$TaskInfo(nameID) >= 0} {
                $_canvas delete $TaskInfo(nameID);
                set TaskInfo(nameID) -1;
            }
            if {$TaskInfo(stateID) >= 0} {
                $_canvas delete $TaskInfo(stateID);
                set TaskInfo(stateID) -1;
            }
            if {$TaskInfo(priorityID) >= 0} {
                $_canvas delete $TaskInfo(priorityID);
                set TaskInfo(priorityID) -1;
            }
            if {$TaskInfo(timeID) >= 0} {
                $_canvas delete $TaskInfo(timeID);
                set TaskInfo(timeID) -1;
            }
            if {$TaskInfo(rect1ID) >= 0} {
                $_canvas delete $TaskInfo(rect1ID);
                set TaskInfo(rect1ID) -1;
            }
            if {$TaskInfo(rect2ID) >= 0} {
                $_canvas delete $TaskInfo(rect2ID);
                set TaskInfo(rect2ID) -1;
            }
            if {$TaskInfo(percentID) >= 0} {
                $_canvas delete $TaskInfo(percentID);
                set TaskInfo(percentID) -1;
            }

            # Put the update task information back into the task
            # table.
            set _taskTable($name) [array get TaskInfo];
        }
        # Else unknown task. Ignore request.

        return -code ok;
    }
}
