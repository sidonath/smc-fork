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
# Task --
#
#  Work for the task manager.
#
# RCS ID
# $Id: TASK.TCL,v 1.6 2009/11/25 22:30:19 cwrapp Exp $
#
# CHANGE LOG
# $Log: TASK.TCL,v $
# Revision 1.6  2009/11/25 22:30:19  cwrapp
# Fixed problem between %fsmclass and sm file names.
#
# Revision 1.5  2008/02/04 12:39:02  fperrad
# fix filename case on linux
#
# Revision 1.4  2005/05/28 18:02:56  cwrapp
# Updated Tcl examples, removed EX6.
#
# Revision 1.0  2003/12/14 20:31:08  charlesr
# Initial revision
#

package require statemap;
source ./TASK_sm.tcl;

class Task {
# Member data.
    private variable _fsm;

    # The task's human-readable name.
    private variable _name;

    # The task's fixed priority.
    private variable _priority;

    # The task's total run time in milliseconds.
    private variable _time;

    # How much run time the task has left.
    private variable _timeLeft;

    # When the task is told to run, remember at what time
    # it started. Then when the task stops running, it can
    # figure out for how long it was running and how much
    # longer it needs to run.
    private variable _runStartTime;

    # When the task is suspended, remember at what time
    # the suspension started. This is necessary in order
    # to calculate the dynamic priority.
    private variable _suspendStartTime;

    # Put internal timers here.
    private variable _timerTable;

    # The timer for updating the percent complete display does
    # not go through the state machine. Keep the timer ID in a
    # separate variable.
    private variable _updateTimerID;

# Member methods.
    constructor {name priority time} {
        set _name $name;
        set _priority $priority;
        set _time [expr $time * 1000];
        set _timeLeft $_time;
        set _runStartTime 0;
        set _updateTimerID -1;

        set _fsm [TASKContext #auto $this];

        # Uncomment to see debug output.
        # _fsm setDebugFlag 1;

        # Since the task starts suspended, timestamp.
        set _suspendStartTime [clock clicks];

        # Have this task placed on the task display.
        guiController postMessage \
                statusGUI taskCreated $_name Suspended $_priority $time;
    }

    destructor {
        # Delete all open timers.
        foreach Timer [array names _timerTable] {
            if {$_timerTable($Timer) >= 0} {
                after cancel $_timerTable($Timer);
                set _timerTable($Timer) -1;
            }
        }
    }

    # getName --
    #
    #   Return this task's name.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   A string containing the task's name.

    public method getName {} {
        return -code ok $_name;
    }

    # getPriority --
    #
    #   Return this task's static priority.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   The task's static priority.

    public method getPriority {} {
        return -code ok $_priority;
    }

    # getTime --
    #
    #   Return the task's total run time in milliseconds.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   The task's total run time in milliseconds.

    public method getTime {} {
        return -code ok $_time;
    }

    # getTimeLeft --
    #
    #   Return the how many more milliseconds are
    #   need to complete this task.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   Time left to run in milliseconds.

    public method getTimeLeft {} {
        return -code ok $_timeLeft;
    }

    # getDynamicPriority --
    #
    #   A task's dynamic priority is equal to its static priority
    #   plus its suspend time + percent complete. Because suspend
    #   time will be > 1000, divide it by 1000.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   Returns an integer representing its dynamic priority.

    public method getDynamicPriority {} {
        return -code ok [expr $_priority + \
                              [expr [$this getSuspendTime] / 1000] + \
                              [$this getPercentComplete]];
    }

    # getSuspendTime --
    #
    #   Return this task's suspended time in milliseconds.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   Return this task's suspended time in milliseconds.

    public method getSuspendTime {} {
        return -code ok [expr [clock clicks] - $_suspendStartTime];
    }

    # getPercentComplete --
    #
    #   ((Total Time - Time Left) / Total Time) * 100
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   Returns an integer between 0 and 100.

    public method getPercentComplete {} {
        return -code ok [expr [expr [expr $_time - $_timeLeft] / \
                                    $_time] * 100];
    }

    # timeout --
    #
    #   A timer has expired. Remove the timer from the
    #   timer table and issue the specified transition.
    #   This method should only be used as a callback to
    #   after.
    #
    # Arguments:
    #   transition  The task manager transition.
    #
    # Results:
    #   None.

    public method timeout {transition} {
        $_fsm $transition;
        return -code ok;
    }

    # The following methods are used to carry out
    # the GUI commands to block or delete.

    # suspend --
    #
    #   Suspend this task.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    public method suspend {} {
        $_fsm Suspend;

        return -code ok;
    }

    # block --
    #
    #   Block this task.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    public method block {} {
        $_fsm Block;

        return -code ok;
    }

    # unblock --
    #
    #   Unblock this task.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    public method unblock {} {
        $_fsm Unblock;

        return -code ok;
    }

    # delete --
    #
    #   Delete this task.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    public method delete {} {
        $_fsm Delete;

        return -code ok;
    }

    # The following methods are accessed by the task manager.

    # start --
    #
    #   Start this task running.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    public method start {} {
        $_fsm Start;
        return -code ok;
    }

    # stop --
    #
    #   Stop this task.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    public method stop {} {
        $_fsm Stop;
        return -code ok;
    }

    # State Machine Actions

    # setTimer --
    #
    #   Create a timer for the specified period. When the timer
    #   expires, issue the specified transition to the state
    #   machine.
    #
    # Arguments:
    #   name    The timer's name.
    #   period  The time in milliseconds.
    #
    # Results:
    #   None.

    public method setTimer {name period} {
        # If there a timer with this name already active?
        if {[llength [array names _timerTable $name]] > 0 && \
                $_timerTable($name) >= 0} {
            # Yes, there is. Stop the current timer and then
            # start it again.
            stopTimer $name;
        }

        set _timerTable($name) [after $period [list $this timeout $name]];

        return -code ok;
    }

    # stopTimer --
    #
    #   Stop the specified timer if it is running.
    #
    # Arguments:
    #   name   The timer's name.
    #
    # Results:
    #   None.

    public method stopTimer {name} {
        # Get the Tcl timer ID from the table.
        if {[catch "set TimerID $_timerTable($name)"] == 0} {
            after cancel $TimerID;
            set _timerTable($name) -1;
        }

        return -code ok;
    }

    # sendMessage --
    #
    #   Send a message to the GUI controller so it can be
    #   posted on the message display.
    #
    # Arguments:
    #   level     The message's importance where 0 is the most
    #            important message and decreasing as the level
    #            increases.
    #   message   The message to be posted.
    #
    # Results:
    #   None.

    public method sendMessage {level message} {
        guiController postMessage \
                messageGUI postMessage $level $_name $message;
        return -code ok;
    }

    # stateUpdate --
    #
    #   Tell the task manager about this task's change in status.
    #
    # Arguments:
    #   change   The task's state change.
    #
    # Results:
    #   None.

    public method stateUpdate {change} {
        guiController postMessage \
                statusGUI taskStateUpdate $_name $change;
        return -code ok;
    }

    # timeUpdate --
    #
    #   Update the task's percent complete display.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    public method timeUpdate {} {
        set _updateTimerID -1;

        set TimeLeft [expr $_timeLeft - \
                            [expr [clock clicks] - \
                                  $_runStartTime]];
        if {$TimeLeft < 0} {
            set TimeLeft 0;
        }

        guiController postMessage \
                statusGUI taskTimeUpdate $_name $TimeLeft;


        if {$TimeLeft > 1000} {
            set _updateTimerID [after 1000 [list $this timeUpdate]];
        }

        return -code ok;
    }

    # setRunTimer --
    #
    #   Set a timer for the task's remaining run time.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    public method setRunTimer {} {
        if {$_timeLeft > 0} {
            setTimer "Done"  $_timeLeft;
        } else {
            setTimer "Done" idle;
        }

        return -code ok;
    }

    # setStartTime --
    #
    #   Remember when this task started running. Since elapsed
    #   time is being calculated, used clock clicks since it
    #   is finer grained that clock seconds.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    public method setStartTime {} {
        # Start the timer which updates the task percent
        # complete display.
        if {$_timeLeft > 1000} {
            set _updateTimerID [after 1000 [list $this timeUpdate]];
        }

        set _runStartTime [clock clicks];

        return -code ok;
    }

    # setStopTime --
    #
    #   Update the time left and stop the update timer.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    public method setStopTime {} {
        set _timeLeft [expr $_timeLeft - \
                            [expr [clock clicks] - \
                                  $_runStartTime]];
        if {$_timeLeft < 0} {
            set _timeLeft 0;
        }

        guiController postMessage \
                statusGUI taskTimeUpdate $_name $_timeLeft;


        if {$_updateTimerID >= 0} {
            after cancel $_updateTimerID;
            set _updateTimerID -1;
        }

        return -code ok;        
    }

    # setSuspendTime --
    #
    #   Remember when this task was suspended.
    #
    # Arugments:
    #   None.
    #
    # Results:
    #   None.

    public method setSuspendTime {} {
        set _suspendStartTime [clock clicks];
        return -code ok;
    }

    # updateTaskMan --
    #
    #   Tell the Task Manager that this task has either
    #   completed or stopped.
    #
    # Arguments:
    #   state   The task's new state.
    #
    # Results:
    #   None.

    public method updateTaskMan {state} {
        guiController postMessage \
                taskManager $state $_name;
        return -code ok;
    }
}
