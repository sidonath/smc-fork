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
# TaskManager --
#
#  Responsible for creating, executing and destroying tasks.
#  Maintains a sorted list of tasks and runs the highest
#  priority task for a specified time slice.
#
# RCS ID
# $Id: taskManager.tcl,v 1.5 2009/11/25 22:30:19 cwrapp Exp $
#
# CHANGE LOG
# $Log: taskManager.tcl,v $
# Revision 1.5  2009/11/25 22:30:19  cwrapp
# Fixed problem between %fsmclass and sm file names.
#
# Revision 1.4  2005/05/28 18:02:56  cwrapp
# Updated Tcl examples, removed EX6.
#
# Revision 1.0  2003/12/14 20:36:00  charlesr
# Initial revision
#

package require statemap;
source ./taskManager_sm.tcl;

class TaskManager {
# Member data.
    private variable _fsm;

    # The queue of runnable tasks sorted by priority.
    private variable _runnableTaskQueue;

    # Tasks that are blocked and so can't run.
    private variable _blockedTaskList;

    # These tasks are dead and are waiting to be deleted.
    private variable _zombieTaskList;

    # This is the task that is currently executing.
    private variable _runningTask;

    # When a timer is created, it's name and associated
    # Tcl timer ID are stored in this array.
    private variable _timerTable;

    # Put the garbage collection timer its own variable.
    private variable _garbageTimerID;

    # Store the application exit code here.
    private variable _exitCode;

# Member functions.
    constructor {} {
        set _runnableTaskQueue {};
        set _blockedTaskList {};
        set _zombieTaskList {};
        set _runningTask "";
        set _garbageTimerID -1;
        set _exitCode 0;

        set _fsm [taskManagerContext #auto $this];

        # Uncomment to see debug output.
        # _fsm setDebugFlag 1;
    }

    destructor {
        # Delete all open timers.
        foreach Timer [array names _timerTable] {
            if {$_timerTable($Timer) >= 0} {
                after cancel $_timerTable($Timer);
                set _timerTable($Timer) -1;
            }
        }

        if {$_garbageTimerID >= 0} {
            after cancel $_garbageTimerID;
            set _garbageTimerID -1;
        }

        # Delete all zombie tasks.
        foreach Task $_zombieTaskList {
            delete object $Task;
        }
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

    # collectGarbage --
    #
    #   Delete all zombie tasks.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    public method collectGarbage {} {
        # Now that the garbage collection timer has expired,
        # reset the timer ID.
        set _garbageTimerID -1;

        foreach Task $_zombieTaskList {
            delete object $Task;
        }
        set _zombieTaskList {};

        return -code ok;
    }

    # These methods are called by the GUI controller.

    # createTask --
    #
    #   Create a new task with the specified parameters.
    #
    # Arguments:
    #   name      Task name.
    #   priority  Task fixed priority.
    #   time      How long the task will run (in seconds).
    #
    # Results:
    #   None.

    public method createTask {name priority time} {
        # Does a task with this name already exist?
        if {[string length $name] == 0} {
            sendMessage 0 "Cannot create task without a name.";
        } elseif {[string length [FindTask $name]] > 0} {
            sendMessage 0 "Cannot create task named \"$name\" - a task with that name already exists.";
        } else {
            set TaskObj [Task #auto $name $priority $time];
            set TaskObj "::TaskManager::$TaskObj";
            lappend _runnableTaskQueue $TaskObj;
            sendMessage 1 "Created task $name (priority: $priority, time: $time)";
            $_fsm TaskCreated;
        }

        return -code ok;
    }

    # suspendTask --
    #
    #   Suspend the runnng task.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    public method suspendTask {} {
        # Is there a task with this name?
        if {[string length $_runningTask] != 0} {
            sendMessage 2 "Suspending task [$_runningTask getName].";
            guiController postMessage \
                    $_runningTask suspend;

            # Put the task back on to the runnable queue.
            lappend _runnableTaskQueue $_runningTask;
            set _runningTask "";
        }

        return -code ok;
    }

    # blockTask --
    #
    #   Block the specified task. If that task is running,
    #   then remove it.
    #
    # Arguments:
    #   taskName   A task object's name.
    #
    # Results:
    #   None.

    public method blockTask {taskName} {
        set Task [FindTask $taskName];

        # Is there a task with this name?
        if {[string length $Task] != 0} {
            sendMessage 2 "Task $taskName is blocked.";
            guiController postMessage \
                    $Task block;

            if {[string compare $Task $_runningTask] == 0} {
                # Put the task on to the blocked list.
                lappend _blockedTaskList $_runningTask;
                set _runningTask "";
            } elseif {[set TaskIndex [lsearch -exact $_runnableTaskQueue $Task]] >= 0} {
                # Move the task from the runnable queue to the
                # blocked queue.
                set _runnableTaskQueue \
                        [lreplace $_runnableTaskQueue \
                                  $TaskIndex \
                                  $TaskIndex];
                lappend _blockedTaskList $Task;
            }
        }

        return -code ok;
    }

    # unblockTask --
    #
    #   Move a task from the blocked list to the runnable queue.
    #
    # Arguments:
    #   taskName   A task object's name.
    #
    # Results:
    #   None.

    public method unblockTask {taskName} {
        set Task [FindTask $taskName];

        # Is there a task with this name?
        if {[string length $Task] != 0} {
            # Is this task on the blocked list?
            if {[set TaskIndex [lsearch -exact $_blockedTaskList $Task]] >= 0} {
                sendMessage 2 "Task $taskName is unblocked.";
                guiController postMessage \
                        $Task unblock;

                # Move the task from the blocked queue to the
                # runnable queue.
                set _blockedTaskList \
                        [lreplace $_blockedTaskList \
                                  $TaskIndex \
                                  $TaskIndex];
                lappend _runnableTaskQueue $Task;

                $_fsm TaskUnblocked;
            }
        }

        return -code ok;
    }

    # deleteTask --
    #
    #   Delete a task.
    #
    # Arguments:
    #   taskName   A task object's name.
    #
    # Results:
    #   None.

    public method deleteTask {taskName} {
        set Task [FindTask $taskName];

        # Is there a task with this name?
        if {[string length $Task] != 0} {
            # Have the task go and die.
            guiController postMessage $Task delete;
        }

        return -code ok;
    }

    # shutdown --
    #
    #   Shutdown this application.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    public method shutdown {} {
        $_fsm Shutdown;

        return -code ok;
    }

    # The following methods are used by task objects
    # to communicate with the task manager.

    # taskDone --
    #
    #   The running task has completed its work.
    #
    # Arguments:
    #   taskName   A task object's name.
    #
    # Results:
    #   None.

    public method taskDone {taskName} {
        set Task [FindTask $taskName];

        if {[string length $Task] > 0} {
            sendMessage 1 "Task $taskName has completed.";

            # Is this the running task?
            if {[string compare $Task $_runningTask] == 0} {
                set _runningTask "";
                $_fsm TaskDone;
            } elseif {[set TaskIndex [lsearch -exact $_runnableTaskQueue $Task]] >= 0} {
                # I don't know how a suspended task managed to
                # complete. Remove it from the runnable list.
                set _runnableTaskQueue \
                        [lreplace $_runnableTaskQueue \
                                  $TaskIndex \
                                  $TaskIndex];
            } elseif {[set TaskIndex [lsearch -exact $_blockedTaskList $task]] >= 0} {
                # I don't know how a blocked task managed to
                # complete. Remove it from the blocked list.
                set _blockedTaskList \
                        [lreplace $_blockedTaskList \
                                  $TaskIndex \
                                  $TaskIndex];
            }

            ZombifyTask $Task;
        }

        return -code ok;
    }

    # taskStopped --
    #
    #   A task has stopped and is ready for shutdown.
    #
    # Arguments:
    #   taskName   A task object's name.
    #
    # Results:
    #   None.

    public method taskStopped {taskName} {
        set Task [FindTask $taskName];

        # Move the state from the blocked list to the zombie.
        if {[set TaskIndex [lsearch -exact $_blockedTaskList $Task]] >= 0} {
            sendMessage 1 "Task $taskName is stopped.";

            set _blockedTaskList \
                    [lreplace $_blockedTaskList \
                              $TaskIndex \
                              $TaskIndex];
            ZombifyTask $Task;

            $_fsm TaskStopped;
        } else {
            sendMessage 4 "TaskManager::taskStopped: $taskName not on blocked list.";
        }

        return -code ok;
    }

    # taskDeleted --
    #
    #   A task has stopped and is ready for deletion.
    #
    # Arguments:
    #   taskName   A task object's name.
    #
    # Results:
    #   None.

    public method taskDeleted {taskName} {
        set Task [FindTask $taskName];

        # Is there a task with this name?
        if {[string length $Task] != 0} {
            sendMessage 1 "Task $taskName deleted.";

            if {[string compare $_runningTask $Task] == 0} {
                set _runningTask "";
                $_fsm TaskDeleted;
            } elseif {[set TaskIndex [lsearch -exact $_runnableTaskQueue $Task]] >= 0} {
                # Move the task from the runnable queue to the
                # blocked queue.
                set _runnableTaskQueue \
                        [lreplace $_runnableTaskQueue \
                                  $TaskIndex \
                                  $TaskIndex];
            } elseif {[set TaskIndex [lsearch -exact $_blockedTaskList $Task]] >= 0} {
                # Move the task from the blocked queue to the
                # runnable queue.
                set _blockedTaskList \
                        [lreplace $_blockedTaskList \
                                  $TaskIndex \
                                  $TaskIndex];
            }

            ZombifyTask $Task;
        }

        return -code ok;
    }

    # State machine actions.

    # getRunnableTaskCount --
    #
    #   Return the number of runnable tasks.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   Return the number of runnable tasks.
    
    public method getRunnableTaskCount {} {
        return -code ok [llength $_runnableTaskQueue];
    }

    # getBlockedTaskCount --
    #
    #   Return the number of blocked tasks.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   Return the number of blocked tasks.
    
    public method getBlockedTaskCount {} {
        return -code ok [llength $_blockedTaskList];
    }

    # getRunningTask --
    #
    #   Return the currently running task.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   Return the currently running task.

    public method getRunningTask {} {
        return -code ok _runningTask;
    }

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
                messageGUI postMessage $level "TaskManager" $message;
        return -code ok;
    }

    # checkTaskQueue --
    #
    #   Check if there are any tasks to run. If yes, then
    #   asynchronously issue a RunTask transition using the
    #   setTimer() method.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    public method checkTaskQueue {} {
        if {[llength $_runnableTaskQueue] > 0} {
            setTimer RunTask idle;
        }

        return -code ok;
    }

    # startTask --
    #
    #   Take the highest priority task off the runnable queue
    #   and have it start running.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    public method startTask {} {
        # Sort the queue by priority.
        set _runnableTaskQueue [lsort -decreasing -command comparePriority $_runnableTaskQueue];

        # Remove the first task from the queue tell it to
        # start up.
        set _runningTask [lindex $_runnableTaskQueue 0];
        set _runnableTaskQueue [lrange $_runnableTaskQueue 1 end];

        sendMessage 2 "Attempting to run task [$_runningTask getName].";

        guiController postMessage \
                $_runningTask start;

        return -code ok;
    }

    # stopAllTimers --
    #
    #   Cancel all Tcl timers.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    public method stopAllTimers {} {
        # If the garbage collection timer is set, then
        # cancel it.
        if {$_garbageTimerID >= 0} {
            after cancel $_garbageTimerID;
            set _garbageTimerID -1;
        }

        # Cancel all other timers.
        foreach Timer [array names _timerTable] {
            if {$_timerTable($Timer) >= 0} {
                after cancel $_timerTable($Timer);
                set _timerTable($Timer) -1;
            }
        }

        return -code ok;
    }

    # stopAllTasks --
    #
    #   Stop all tasks.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   None.

    public method stopAllTasks {} {
        # Put all tasks into the blocked list. As they report
        # that they are stopped, move the tasks into the zombie
        # list.
        #
        # Do the blocked list first.
        foreach Task $_blockedTaskList {
            sendMessage 3 "Stopping task [$Task getName].";
            guiController postMessage \
                    $Task stop;
        }

        # Do the waiting tasks next.
        foreach Task $_runnableTaskQueue {
            sendMessage 3 "Stopping task [$Task getName].";
            guiController postMessage \
                    $Task stop;
            lappend _blockedTaskList $Task;
        }
        set _runnableTaskQueue {};

        # Do the running task last.
        if {[string length $_runningTask] > 0} {
            sendMessage 3 "Stopping task [$_runningTask getName].";
            guiController postMessage \
                    $_runningTask stop;
            lappend _blockedTaskList $_runningTask;
            set _runningTask "";
        }

        return -code ok;
    }

    # deleteRunningTask --
    #
    #   Delete the running task object.
    #
    # Arugments:
    #   None.
    #
    # Results:
    #   None.

    public method deleteRunningTask {} {
        if {[string length $_runningTask] > 0} {
            ZombifyTask $_runningTask;
            set _runningTask "";
        }

        return -code ok;
    }

    # deleteAllTasks --
    #
    #   Forcibly delete all existing tasks with predjudice.
    #
    # Arugments:
    #   None.
    #
    # Results:
    #   None.

    public method deleteAllTasks {} {
        if {[string length $_runningTask] > 0} {
            delete object $_runningTask;
            set _runningTask "";
        }

        foreach Task $_runnableTaskQueue {
            delete object $Task;
        }
        set _runnableTaskQueue {};

        foreach Task $_blockedTaskList {
            delete object $Task;
        }
        set _blockedTaskList {};
        
        return -code ok;
    }

    # exitApplication --
    #
    #   Exit this application.
    #
    # Arugments:
    #   exitCode  Upon exit, return this integer value.
    #
    # Results:
    #   None.

    public method exitApplication {exitCode} {
        after 1500 [list exit $exitCode];
        return -code ok;
    }

    # ZombifyTask --
    #
    #   Put a task on the zombie list for later deletion.
    #   Start the garbage collection timer. When it expires,
    #   delete all the tasks on the zombie list.
    #
    # Arguments:
    #   task   A task object.
    #
    # Results:
    #   None.

    private method ZombifyTask {task} {
        # Check if this object is already a zombie.
        if {[lsearch -exact $_zombieTaskList $task] < 0} {
            lappend _zombieTaskList $task;
        }

        # If the garbage collection timer is not running,
        # then start it now.
        if {$_garbageTimerID < 0} {
            after idle [list $this collectGarbage];
        }

        return -code ok;
    }

    # FindTask --
    #
    #   Find a task object with the specified name and return
    #   the object.
    #
    # Arguments:
    #   taskName   A task object's name.
    #
    # Results:
    #   If a task is found with the given name, then the task
    #   object is returned. If not found, then the empty string
    #   is returned.

    private method FindTask {taskName} {
        set Retval "";

        # Is the running task the one we are looking for?
        if {[string length $_runningTask] > 0 && \
                [string compare [$_runningTask getName] $taskName] == 0} {
            set Retval $_runningTask;
        } else {
            # Is the task in the runnable queue?
            foreach Task $_runnableTaskQueue {
                if {[string compare [$Task getName] $taskName] == 0} {
                    set Retval $Task;
                    break;
                }
            }

            # Is the task in the blocked list?
            if {[string length $Retval] == 0} {
                foreach Task $_blockedTaskList {
                    if {[string compare [$Task getName] $taskName] == 0} {
                        set Retval $Task;
                        break;
                    }
                }
            }
        }

        return -code ok $Retval;
    }
}

# comparePriority --
#
#   Have both tasks return their dynamic priorities and compare
#   the returned values.
#
# Arguments:
#   lhs   A task object.
#   rhs   A task object.
#
# Results:
#   If the lhs task's priority is less than the rhs task, then
#   -1 is returned. If the lhs task's priority is equal to the
#   rhs, then 0 is returned. If the lhs task's priority is
#   greater than the rhs, then 1 is returned.

proc comparePriority {lhs rhs} {
    set LhsPriority [$lhs getDynamicPriority];
    set RhsPriority [$rhs getDynamicPriority];

    if {$LhsPriority < $RhsPriority} {
        set Retval -1;
    } elseif {$LhsPriority > $RhsPriority} {
        set Retval 1;
    } else {
        set Retval 0;
    }

    return -code ok $Retval;
}
