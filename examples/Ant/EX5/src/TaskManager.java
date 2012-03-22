//
// The contents of this file are subject to the Mozilla Public
// License Version 1.1 (the "License"); you may not use this file
// except in compliance with the License. You may obtain a copy
// of the License at http://www.mozilla.org/MPL/
// 
// Software distributed under the License is distributed on an
// "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
// implied. See the License for the specific language governing
// rights and limitations under the License.
// 
// The Original Code is State Machine Compiler (SMC).
// 
// The Initial Developer of the Original Code is Charles W. Rapp.
// Portions created by Charles W. Rapp are
// Copyright (C) 2000 - 2003 Charles W. Rapp.
// All Rights Reserved.
// 
// Contributor(s): 
//
// Name
//  TaskManager.java
//
// Description
//  This singleton is responsible for scheduling the running
//  task.
//
// RCS ID
// $Id: TaskManager.java,v 1.2 2007/08/05 13:14:57 cwrapp Exp $
//
// CHANGE LOG
// $Log: TaskManager.java,v $
// Revision 1.2  2007/08/05 13:14:57  cwrapp
// Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
//
// Revision 1.1  2005/05/28 12:49:21  cwrapp
// Added Ant examples 1 - 7.
//
// Revision 1.0  2004/05/31 13:20:00  charlesr
// Initial revision
//

package smc_ex5;

import javax.swing.Timer;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.ListIterator;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

public final class TaskManager
    implements TaskEventListener
{
// Member Methods.

    public TaskManager()
    {
        TaskController control = new TaskController();

        _runningTask = null;
        _runnableTaskQueue = new LinkedList();
        _blockedTaskList = new LinkedList();
        _timerTable = new HashMap();
        _exitCode = 0;

        _fsm = new TaskManagerContext(this);

        // Uncomment to see debug output.
        // _fsm.setDebugFlag(true);

        // Register with the controller.
        control.register("Task Manager", this);
    }

    //===========================================================
    // These methods respond to viewer messages.
    //

    // Create a new task.
    public void createTask(String name, int time, int priority)
    {
        if (name == null || name.length() == 0)
        {
            sendMessage(0, "Cannot create task without a name.");
        }
        else if (taskExists(name) == true)
        {
            sendMessage(0,
                        "Cannot create task named \"" +
                        name +
                        "\" - a task with that name already exists.");
        }
        else
        {
            Task newTask = new Task(name, priority, time);
            _runnableTaskQueue.add(newTask);
            sendMessage(1,
                        "Created task " +
                        name +
                        "(priority: " +
                        Integer.toString(priority) +
                        ", time: " +
                        Integer.toString(time) +
                        ").");

            _fsm.TaskCreated();
        }

        return;
    }

    // Suspend the currently running task - if there is one.
    public void suspendTask()
    {
        if (_runningTask != null)
        {
            TaskController control = new TaskController();

            sendMessage(2,
                        "Suspending task " +
                        _runningTask.getName() +
                        ".");

            // Tell the task to suspend.
            control.postMessage(_runningTask.getName(),
                                "suspend");

            // Put the task back on to the runnable queue.
            _runnableTaskQueue.add(_runningTask);
            _runningTask = null;
        }

        return;
    }

    // Block the specified task. If that task is running,
    // then remove it.
    public void blockTask(String taskName)
    {
        Task task;

        if ((task = findTask(taskName)) != null)
        {
            TaskController control = new TaskController();

            sendMessage(2, "Task " + taskName + " is blocked.");

            // Tell the task to block.
            control.postMessage(taskName,
                                "block");

            if (task == _runningTask)
            {
                _runningTask = null;
            }
            else
            {
                // Remove the task from the runnable queue.
                _runnableTaskQueue.remove(task);
            }

            _blockedTaskList.add(task);
        }

        return;
    }

    public void unblockTask(String taskName)
    {
        Task task;
        int taskIndex;

        // Is there a task with this name?
        if ((task = findTask(taskName)) != null)
        {
            // Is this task on the blocked list?
            if ((taskIndex = _blockedTaskList.indexOf(task)) >= 0)
            {
                TaskController control = new TaskController();

                sendMessage(2,
                            "Task " +
                            taskName +
                            " is unblocked.");

                // Tell the task it is now unblocked.
                control.postMessage(task.getName(),
                                    "unblock");

                // Move the task from the blocked queue to the
                // runnable queue.
                _blockedTaskList.remove(taskIndex);
                _runnableTaskQueue.add(task);

                _fsm.TaskUnblocked();
            }
        }

        return;
    }

    public void deleteTask(String taskName)
    {
        Task task;

        if ((task = findTask(taskName)) != null)
        {
            TaskController control = new TaskController();

            // Tell the task to go and die.
            control.postMessage(taskName, "delete");
        }

        return;
    }

    // Shutting down the application.
    public void shutdown()
    {
        _fsm.Shutdown();
        return;
    }

    //===========================================================
    // These methods handle task object messages.
    //

    // The running task has completed its work.
    public void taskDone(String taskName)
    {
        Task task;
        int taskIndex;

        if ((task = findTask(taskName)) != null)
        {
            sendMessage(1,
                        "Task " + taskName + " has completed.");

            // Is this the running task?
            if (task == _runningTask)
            {
                _runningTask = null;
                _fsm.TaskDone();
            }
            else if ((taskIndex =
                      _runnableTaskQueue.indexOf(task)) >= 0)
            {
                // I don't know how a suspended task managed to
                // complete. Remove it from a runnable list.
                _runnableTaskQueue.remove(taskIndex);
            }
            else if ((taskIndex =
                      _blockedTaskList.indexOf(task)) >= 0)
            {
                // I don't know how a blocked task managed to
                // complete. Remove it from the blocked list.
                _blockedTaskList.remove(taskIndex);
            }
        }

        return;
    }

    // A task has stopped and is ready for deletion.
    public void taskStopped(String taskName)
    {
        Task task;
        int taskIndex;

        if ((task = findTask(taskName)) != null &&
            (taskIndex = _blockedTaskList.indexOf(task)) >= 0)
        {
            sendMessage(1, "Task " + taskName + " is stopped.");
            _blockedTaskList.remove(taskIndex);
            _fsm.TaskStopped();
        }
        else
        {
            sendMessage(4,
                        "TaskManager::taskStopped: " +
                        taskName +
                        " not on blocked list.");
        }

        return;
    }

    // A task has stopped and is ready for deletion.
    public void taskDeleted(String taskName)
    {
        Task task;
        int taskIndex;

        if ((task = findTask(taskName)) != null)
        {
            sendMessage(1, "Task " + taskName + " deleted.");

            if (task == _runningTask)
            {
                _runningTask = null;
                _fsm.TaskDeleted();
            }
            else if ((taskIndex = _runnableTaskQueue.indexOf(task))
                         >= 0)
            {
                _runnableTaskQueue.remove(taskIndex);
            }
            else if ((taskIndex = _blockedTaskList.indexOf(task))
                         >= 0)
            {
                _blockedTaskList.remove(taskIndex);
            }
        }

        return;
    }

    //===========================================================
    // State machine actions.
    //

    // Create a timer for the specified period. When the timer
    // expires, issue the corresponding state machine transition.
    public void setTimer(String name, int period)
    {
        Timer timer;

        // Is there a timer with this name already?
        if (_timerTable.containsKey(name) == true)
        {
            // Yes, there is. Stop the current timer and then
            // start it again.
            stopTimer(name);
        }

        timer = new Timer(period,
                          new TimerListener(name, this));
        timer.setRepeats(false);
        _timerTable.put(name, timer);

        // Start the timer running.
        timer.start();

        return;
    }

    // Stop the named timer if it is running.
    public void stopTimer(String name)
    {
        Timer timer;

        // Remove the timer from the table and stop it.
        if ((timer = (Timer) _timerTable.remove(name)) != null)
        {
            timer.stop();
        }

        return;
    }

    // Send a message to the GUI controller so it can be posted
    // on the message display.
    public void sendMessage(int level, String message)
    {
        TaskController control = new TaskController();
        Map args = new HashMap();

        args.put("level", new Integer(level));
        args.put("object", "TaskManager");
        args.put("message", message);
        control.postMessage("Message GUI",
                            "Post Message",
                            args);

        return;
    }

    // Check if there are any tasks to run. If yes, then
    // asynchronously issue a RunTask transition using the
    // setTimer() method.
    public void checkTaskQueue()
    {
        if (_runnableTaskQueue.size() > 0)
        {
            // Create a timer which will expire immediately.
            setTimer("Run Task", 0);
        }

        return;
    }

    // Return the currently running task.
    public Task getRunningTask()
    {
        return (_runningTask);
    }

    // Return the number of runnable tasks.
    public int getRunnableTaskCount()
    {
        return (_runnableTaskQueue.size());
    }

    // Return the number of blocked tasks.
    public int getBlockedTaskCount()
    {
        return (_blockedTaskList.size());
    }

    // Check if there are any tasks to run.
    public boolean areTasksQueued()
    {
        return (_runnableTaskQueue.size() > 0);
    }

    // Task the highest priority task off the runnable queue
    // and have it start running.
    public void startTask()
    {
        ListIterator taskIt;
        Task task;
        int index;
        int taskIndex;
        int taskPriority;
        int currentMinPriority;

        // Find the task with the lowest priority.
        for (taskIt = _runnableTaskQueue.listIterator(0),
                     currentMinPriority = Integer.MAX_VALUE,
                     index = 0,
                     taskIndex = -1;
             taskIt.hasNext() == true;
             ++index)
        {
            task = (Task) taskIt.next();
            taskPriority = task.getDynamicPriority();

            // Is the new task's priority less than
            // the current task. 
            if (taskPriority < currentMinPriority)
            {
                taskIndex = index;
                currentMinPriority = taskPriority;
            }
        }

        // Was a task found?
        if (taskIndex >= 0)
        {
            TaskController control = new TaskController();

            _runningTask =
                    (Task) _runnableTaskQueue.remove(taskIndex);
             sendMessage(2,
                         "Attempting to run task " +
                         _runningTask.getName() +
                         ".");

             control.postMessage(_runningTask.getName(),
                                 "start");
        }

        return;
    }

    // Cancel all existing timers.
    public void stopAllTimers()
    {
        Iterator entryIt;
        Map.Entry mapEntry;
        Timer timer;

        for (entryIt = _timerTable.entrySet().iterator();
             entryIt.hasNext() == true;
             )
        {
            mapEntry = (Map.Entry) entryIt.next();
            timer = (Timer) mapEntry.getValue();
            timer.stop();
        }

        _timerTable.clear();

        return;
    }

    public void stopAllTasks()
    {
        TaskController control = new TaskController();
        ListIterator listIt;
        Task task;

        // Put all tasks into the blocked list. As they report
        // that they are stopped, remove the tasks.
        //
        // Do the blocked list first.
        for (listIt = _blockedTaskList.listIterator(0);
             listIt.hasNext() == true;
             )
        {
            task = (Task) listIt.next();

            sendMessage(3,
                        "Stopping task " +
                        task.getName() +
                        ".");
            control.postMessage(task.getName(),
                                "stop");
        }

        // Do the runnable tasks next.
        for (listIt = _runnableTaskQueue.listIterator(0);
             listIt.hasNext() == true;
             )
        {
            task = (Task) listIt.next();

            sendMessage(3,
                        "Stopping task " +
                        task.getName() +
                        ".");
            control.postMessage(task.getName(),
                                "stop");
            _blockedTaskList.add(task);
        }
        _runnableTaskQueue.clear();

        // Do the running task last.
        if (_runningTask != null)
        {
            sendMessage(3,
                        "Stopping task " +
                        _runningTask.getName() +
                        ".");
            control.postMessage(_runningTask.getName(),
                                "stop");
            _blockedTaskList.add(_runningTask);
            _runningTask = null;
        }

        return;
    }

    public void deleteRunningTask()
    {
        if (_runningTask != null)
        {
            _runningTask = null;
        }

        return;
    }

    // Forcibly delete all existing tasks with extreme prejudice.
    public void deleteAllTasks()
    {
        _runningTask = null;
        _runnableTaskQueue.clear();
        _blockedTaskList.clear();

        return;
    }

    public void exitApplication()
    {
        // Wait another 1.5 secs before actually dying.
        setTimer("Exit", 1500);
        return;
    }

    public Task findTask(String taskName)
    {
        ListIterator taskIt;
        Task task;
        Task retval;

        retval = null;

        // Is the running task the one we are looking for?
        if (_runningTask != null &&
            taskName.compareTo(_runningTask.getName()) == 0)
        {
            retval = _runningTask;
        }
        else
        {
            // Is the task in the runnable queue?
            for (taskIt = _runnableTaskQueue.listIterator(0);
                 taskIt.hasNext() == true && retval == null;
                )
            {
                task = (Task) taskIt.next();
                if (taskName.compareTo(task.getName()) == 0)
                {
                    retval = task;
                }
            }

            // Is this task in the blocked list?
            if (retval == null)
            {
                for (taskIt = _blockedTaskList.listIterator(0);
                     taskIt.hasNext() == true && retval == null;
                    )
                {
                    task = (Task) taskIt.next();
                    if (taskName.compareTo(task.getName()) == 0)
                    {
                        retval = task;
                    }
                }
            }
        }

        return(retval);
    }

    // Does a task already exist with this name?
    public boolean taskExists(String name)
    {
        return(findTask(name) == null ? false : true);
    }

    // Issue the state machine transition associated with this timer
    // name. Also, remove the now defunct timer from the timer
    // table.
    public void handleEvent(String eventName, Map args)
    {
        String taskName;

        if (eventName.compareTo("Create Task") == 0)
        {
            Integer runtime;
            Integer priority;

            taskName = (String) args.get("Task Name");
            runtime = (Integer) args.get("Runtime");
            priority = (Integer) args.get("Priority");
            createTask(taskName,
                       runtime.intValue(),
                       priority.intValue());
        }
        else if (eventName.compareTo("Run Task") == 0)
        {
            _fsm.RunTask();
        }
        else if (eventName.compareTo("Slice Timeout") == 0)
        {
            _fsm.SliceTimeout();
        }
        else if (eventName.compareTo("Reply Timeout") == 0)
        {
            _fsm.ReplyTimeout();
        }
        else if (eventName.compareTo("Suspend Task") == 0)
        {
            suspendTask();
        }
        else if (eventName.compareTo("Block Task") == 0)
        {
            taskName = (String) args.get("Task Name");
            blockTask(taskName);
        }
        else if (eventName.compareTo("Unblock Task") == 0)
        {
            taskName = (String) args.get("Task Name");
            unblockTask(taskName);
        }
        else if (eventName.compareTo("Delete Task") == 0)
        {
            taskName = (String) args.get("Task Name");
            deleteTask(taskName);            
        }
        else if (eventName.compareTo("Task Suspended") == 0)
        {
            taskName = (String) args.get("Task Name");
            sendMessage(2,
                        "Task " +
                        taskName +
                        " has been suspended.");

            _fsm.TaskSuspended();
        }
        else if (eventName.compareTo("Task Done") == 0)
        {
            taskName = (String) args.get("Task Name");
            taskDone(taskName);
        }
        else if (eventName.compareTo("Task Stopped") == 0)
        {
            taskName = (String) args.get("Task Name");
            taskStopped(taskName);
        }
        else if (eventName.compareTo("Task Deleted") == 0)
        {
            taskName = (String) args.get("Task Name");
            taskDeleted(taskName);
        }
        else if (eventName.compareTo("Shutdown") == 0)
        {
            Integer exitCode;

            exitCode = (Integer) args.get("Exit Code");
            _exitCode = exitCode.intValue();

            _fsm.Shutdown();
        }
        else if (eventName.compareTo("Exit") == 0)
        {
            System.exit(_exitCode);
        }
        else if (eventName.compareTo("ShutdownTimeout") == 0)
        {
            _fsm.ShutdownTimeout();
        }

        return;
    }

// Member Data.

    private TaskManagerContext _fsm;

    // Runnable task queue, sorted by priority.
    private LinkedList _runnableTaskQueue;

    // Blocked task list.
    private LinkedList _blockedTaskList;

    // The currently running task.
    private Task _runningTask;

    // Task manager's various timers.
    private Map _timerTable;

    // The application's exit code.
    private int _exitCode;

// Inner classes.

    private final class TimerListener
        implements ActionListener
    {
        public TimerListener(String name,
                             TaskManager owner)
        {
            _timerName = name;
            _owner = owner;
        }

        public void actionPerformed(ActionEvent e)
        {
            Map args = new HashMap();

            _owner.handleEvent(_timerName, args);
            return;
        }

        private String _timerName;
        private TaskManager _owner;
    }
}
