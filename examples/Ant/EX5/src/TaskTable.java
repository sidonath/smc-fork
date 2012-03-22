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
//  TaskTable.java
//
// Description
//  Displays each existing tasks' status and percent complete
//  information.
//
// RCS ID
// $Id: TaskTable.java,v 1.2 2007/08/05 13:14:57 cwrapp Exp $
//
// CHANGE LOG
// $Log: TaskTable.java,v $
// Revision 1.2  2007/08/05 13:14:57  cwrapp
// Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
//
// Revision 1.1  2005/05/28 12:49:21  cwrapp
// Added Ant examples 1 - 7.
//
// Revision 1.0  2004/05/31 13:21:49  charlesr
// Initial revision
//

package smc_ex5;

import javax.swing.SwingConstants;
import javax.swing.JComponent;
import javax.swing.JScrollPane;
import javax.swing.JProgressBar;
import javax.swing.JTable;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.TableColumn;
import javax.swing.Timer;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseAdapter;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.ListIterator;
import java.util.Map;

// This class displays the status of existing tasks.
public final class TaskTable
    implements TaskEventListener
{
// Member Methods

    public TaskTable()
    {
        TaskController control = new TaskController();

        _timerTable = new HashMap();

        // Create the pop-up menu which is associated with the
        // table but actually is row dependent.
        _taskPopupMenu = new TaskPopupMenu();

        _taskTableModel = new TaskTableModel();
        _taskTable = new JTable(_taskTableModel)
        {
            public TableCellRenderer getCellRenderer(int row, int column)
            {
                TableColumn tableColumn = getColumnModel().getColumn(column);
                TableCellRenderer renderer = tableColumn.getCellRenderer();
                if (renderer == null)
                {
                    Class c = getColumnClass(column);
                    if( c.equals(Object.class) )
                    {
                        Object o = getValueAt(row, column);
                        if( o != null )
                        {
                            c = getValueAt(row,column).getClass();
                        }
                    }

                     renderer = getDefaultRenderer(c);
                }

                return(renderer);
            }
        };

        _taskTable.setPreferredScrollableViewportSize(new Dimension(500, 105));
        _taskTable.setRowHeight(20);

        _taskTable.setDefaultRenderer(JComponent.class,
                                      new JComponentCellRenderer());

        // Have the scrollable pane catch the mouse event but
        // interpret it through the task table.
        _taskTable.addMouseListener(new MouseAdapter() {
            public void mousePressed(MouseEvent e) {
                maybeShowPopup(e);
                return;
            }

            public void mouseReleased(MouseEvent e) {
                maybeShowPopup(e);
                return;
            }

            private void maybeShowPopup(MouseEvent e) {
                int row;
                String taskName;
                String status;

                row = _taskTable.rowAtPoint(e.getPoint());

                // Display the task pop-up menu IF this
                // mouse event is over a task on the table AND
                // the task is NOT is the DONE state.
                // Ignore the fact that the event is a not a
                // pop-up trigger.
                if (row >= 0 &&
                    row < _taskTableModel.getRowCount())
                {
                    taskName = _taskTableModel.getTaskNameAt(row);
                    status = _taskTableModel.getStatusAt(row);
                    if (status.compareTo("Done") != 0)
                    {
                        _taskPopupMenu.activate(taskName,
                                                status,
                                                e);
                    }
                }

                return;
            }
        });

        //Create the scroll pane and add the table to it. 
        _pane = new JScrollPane(_taskTable);

        control.register("Task GUI", this);
    }

    public Component getComponents()
    {
        return((Component) _pane);
    }

    public void handleEvent(String event, Map args)
    {
        String name;
        String status;
        Integer runtime;
        Integer priority;
        Integer percentComplete;

        if (event.compareTo("Task Created") == 0)
        {
            name = (String) args.get("name");
            status = (String) args.get("status");
            runtime = (Integer) args.get("runtime");
            priority = (Integer) args.get("priority");

            // Add the task to the table's bottom.
            _taskTableModel.addRow(name,
                                   status,
                                   runtime,
                                   priority);
        }
        else if (event.compareTo("Task State Update") == 0)
        {
            name = (String) args.get("name");
            status = (String) args.get("status");

            // Update the row.
            updateTaskStatus(name, status);
        }
        else if (event.compareTo("Task % Update") == 0)
        {
            int rowIndex;

            name = (String) args.get("name");
            percentComplete = (Integer) args.get("percentComplete");

            // Find the task's row based on the task's name.
            rowIndex = _taskTableModel.findRow(name);

            // Update the row.
            _taskTableModel.setValueAt(percentComplete, rowIndex, 4);
        }
        else if (event.compareTo("Remove Task") == 0)
        {
            name = (String) args.get("name");

            // Remove the timer from the table.
            _timerTable.remove(name);

            _taskTableModel.removeRow(name);
        }

        return;
    }

    // Update a task's status.
    private void updateTaskStatus(String taskName, String status)
    {
        int rowIndex;

        // Find the task's row based on the task's name.
        rowIndex = _taskTableModel.findRow(taskName);

        _taskTableModel.setValueAt(status, rowIndex, 1);

        // If this status is either "Done" or "Deleted", then
        // start a timer to remove this row after a short time.
        // This will give the user a chance to read the new
        // state before the task disappears.
        if (status.compareTo("Done") == 0 ||
            status.compareTo("Deleted") == 0 ||
            status.compareTo("Stopped") == 0)
        {
            setRemoveTimer(taskName);
        }

        return;
    }

    private void setRemoveTimer(String taskName)
    {
        // Create the timer only if it does not already exist.
        if (_timerTable.containsKey(taskName) == false)
        {
            Timer timer;

            timer = new Timer(REMOVE_TIMEOUT,
                              new RemoveTimerListener(taskName,
                                                      this));
            timer.setRepeats(false);
            _timerTable.put(taskName, timer);

            timer.start();
        }

        return;
    }

// Member Data

    private JTable _taskTable;
    private TaskTableModel _taskTableModel;
    private TaskPopupMenu _taskPopupMenu;
    private JScrollPane _pane;

    // Put internal timers here.
    private Map _timerTable;

    // How long we should wait before removing tasks.
    private static final int REMOVE_TIMEOUT = 2000;

// Inner Classes

    private final class TaskTableModel
        extends AbstractTableModel
    {
        public int getColumnCount()
        {
            return(_columnNames.length);
        }
        
        public int getRowCount()
        {
            return(_data.size());
        }

        public String getColumnName(int col)
        {
            return(_columnNames[col]);
        }

        public Object getValueAt(int row, int col)
            throws IndexOutOfBoundsException
        {
            Object retval;
            Object[] taskRow;

            if (row < 0 || row >= _data.size())
            {
                IndexOutOfBoundsException exception =
                        new IndexOutOfBoundsException();
                throw(exception);
            }
            else
            {
                taskRow = (Object[]) _data.get(row);
                retval = taskRow[col];
            }

            return(retval);
        }

        public Class getColumnClass(int c)
        {
            return(getValueAt(0, c).getClass());
        }

        public String getTaskNameAt(int row)
        {
            return((String) getValueAt(row, 0));
        }

        public String getStatusAt(int row)
        {
            return((String) getValueAt(row, 1));
        }

        public int getRuntimeAt(int row)
        {
            return(((Integer) getValueAt(row, 2)).intValue());
        }

        public int getPriorityAt(int row)
        {
            return(((Integer) getValueAt(row, 3)).intValue());
        }

        public boolean isCellEditable(int row, int col)
        {
            boolean retval;

            // The pop-up menu can be displayed if the status
            // is not "Done".
            if (getStatusAt(row).compareTo("Done") != 0)
            {
                retval = true;
            }
            else
            {
                retval = false;
            }

            return(retval);
        }

        // Only the status and percent complete fields can
        // be changed.
        public void setValueAt(Object value, int row, int col)
        {
            if (row >= 0 && row < _data.size())
            {
                Object[] taskRow = (Object[]) _data.get(row);

                // Only the status and percent complete can be
                // updated.
                if (col == 1)
                {
                    taskRow[col] = (String) value;
                    fireTableCellUpdated(row, col);
                }
                else if (col == 4)
                {
                    JProgressBar bar = (JProgressBar) taskRow[4];
                    Integer progress = (Integer) value;
                    bar.setValue(progress.intValue());
                    fireTableCellUpdated(row, col);
                }
                // else ignore changes to any other column.
            }

            return;
        }

        private TaskTableModel()
        {
            _data = new LinkedList();
        }

        // Add a new row to the table.
        private void addRow(String name,
                            String status,
                            Integer runtime,
                            Integer priority)
        {
            int i;
            int rowIndex = _data.size();
            Object[] taskRow = new Object[5];
            JProgressBar bar;

            // The last column is actually a progress bar.
            bar = new JProgressBar(SwingConstants.HORIZONTAL,
                                   0,
                                   100);
            bar.setValue(0);
            bar.setStringPainted(true);

            taskRow[0] = name;
            taskRow[1] = status;
            taskRow[2] = runtime;
            taskRow[3] = priority;
            taskRow[4] = bar;
            _data.add(taskRow);

            fireTableRowsInserted(rowIndex, rowIndex);
        }

        // Remove the specified row from the table.
        private void removeRow(String name)
        {
            int rowIndex;
            int rowCount;

            // Find the task's current row index and the
            // current table size.
            rowIndex = _taskTableModel.findRow(name);
            rowCount = _data.size();

            // Remove the task from the model data and from
            // the table.
            _data.remove(rowIndex);
            fireTableRowsDeleted(rowIndex, rowIndex);

            return;
        }

        private int findRow(String name)
        {
            ListIterator it;
            int i;
            int retval;
            Object[] row;

            for (it = _data.listIterator(0),
                         i = 0,
                         retval = -1;
                 retval < 0 && it.hasNext() == true;
                 ++i)
            {
                row = (Object[]) it.next();
                if (name.compareTo((String) row[0]) == 0)
                {
                    retval = i;
                }
            }

            return(retval);
        }

        private final String[] _columnNames = {
            "Task Name", "State", "Runtime (secs.)",
                "Priority", "% Complete"
        };

        private LinkedList _data;
    }

    private final class JComponentCellRenderer
        implements TableCellRenderer
    {
        public Component getTableCellRendererComponent(JTable table,
                                                       Object value,
                                                       boolean isSelected,
                                                       boolean hasFocus,
                                                       int row,
                                                       int column)
        {
            return((JComponent) value);
        }
    }

    private final class RemoveTimerListener
        implements ActionListener
    {
        private RemoveTimerListener(String name, TaskTable owner)
        {
            super();

            _taskName = name;
            _owner = owner;
        }

        public void actionPerformed(ActionEvent e)
        {
            Map args = new HashMap();

            args.put("name", _taskName);
            _owner.handleEvent("Remove Task", args);

            return;
        }

        private String _taskName;
        private TaskTable _owner;
    }
}
