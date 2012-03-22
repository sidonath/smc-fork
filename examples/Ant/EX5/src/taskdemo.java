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
//  taskdemo.java
//
// Description
//  The taskdemo application. Creates the main GUI frame and the
//  task creation dialog.
//
// RCS ID
// $Id: taskdemo.java,v 1.2 2007/08/05 13:14:57 cwrapp Exp $
//
// CHANGE LOG
// $Log: taskdemo.java,v $
// Revision 1.2  2007/08/05 13:14:57  cwrapp
// Version 5.0.1 check-in. See net/sf/smc/CODE_README.txt for more information.
//
// Revision 1.1  2005/05/28 12:49:21  cwrapp
// Added Ant examples 1 - 7.
//
// Revision 1.0  2004/05/31 13:22:44  charlesr
// Initial revision
//

package smc_ex5;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JSlider;
import javax.swing.SwingConstants;
import javax.swing.UIManager;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.HashMap;
import java.util.Map;

public final class taskdemo
{
// Member Methods.
    public static void main(String[] args)
    {
        try
        {
            UIManager.setLookAndFeel(
                UIManager.getCrossPlatformLookAndFeelClassName());
        }
        catch (Exception e) { }

        // This application uses the model/view/controller
        // pattern. The controller is responsible for routing
        // messages between the view (GUI objects) and the
        // model (back-end objects).
        // Create the model, view and controller objects.

        // TaskManager model "runs" the jobs.
        TaskManager taskManager = new TaskManager();

        // Create the top-level container and add contents to it.
        JFrame frame = new JFrame("Task Demo");
        taskdemo app = new taskdemo();

        app.createComponents(frame.getContentPane());

        // Finish up setting up the frame and show it.
        frame.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                // The window is going away NOW. Just exit.
                System.exit(0);
            }
        });
        frame.pack();
        frame.setVisible(true);
    }

    public taskdemo() {}

    public void createComponents(Container pane)
    {
        // Create the task dialog but don't display it.
        _taskDialog = new TaskDialog();

        // Display all existing tasks in a table.
        _taskTable = new TaskTable();

        // Create scrollable text window to display messages.
        _taskMessages = new TaskMessages(1);

        // Add a slider for setting the allowed message level.
        _levelSlider = new JSlider(JSlider.HORIZONTAL,
                                   0,
                                   5,
                                   1);
        _levelSlider.addChangeListener(new ChangeListener() {
            public void stateChanged(ChangeEvent e) {
                JSlider slider = (JSlider) e.getSource();
                TaskController control = new TaskController();
                Map args = new HashMap();

                args.put("level",
                         new Integer(slider.getValue()));
                control.postMessage("Message GUI",
                                    "Set Level",
                                    args);

                return;
            }
        });
        _levelSlider.setMajorTickSpacing(1);
        _levelSlider.setPaintTicks(true);
        _levelSlider.setPaintLabels(true);
        _levelSlider.setSnapToTicks(true);
        // _levelSlider.setMinimumSize(new Dimension(90, 50));

        _levelLabel = new JLabel("Message Level: ");
        _levelLabel.setLabelFor(_levelSlider);
        _levelLabel.setVerticalTextPosition(SwingConstants.CENTER);
        _levelLabel.setHorizontalTextPosition(SwingConstants.RIGHT);

        // There are two buttons: "Create Task..." and "Quit".
        // The first button makes visible the task dialog, the
        // seconds stops the demo.
        _createButton = new JButton("Create Task...");
        _createButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                _taskDialog.activate();
            }
        });
        _createButton.setEnabled(true);

        _quitButton = new JButton("Quit");
        _quitButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                TaskController control = new TaskController();
                Map args = new HashMap();

                args.put("Exit Code", new Integer(0));
                control.postMessage("Task Manager",
                                    "Shutdown",
                                    args);
            }
        });
        _quitButton.setEnabled(true);

        // Layout the components.
        GridBagLayout gridbag = new GridBagLayout();
        GridBagConstraints gridConstraints = new GridBagConstraints();
        pane.setLayout(gridbag);

        // Put table's scrollable pane inside this pane.
        gridConstraints.anchor = GridBagConstraints.NORTH;
        gridConstraints.gridx = 0;
        gridConstraints.gridy = 0;
        gridConstraints.gridwidth = GridBagConstraints.REMAINDER;
        gridConstraints.gridheight = 1;
        gridbag.setConstraints(_taskTable.getComponents(),
                               gridConstraints);
        pane.add(_taskTable.getComponents());

        // Put the message display up.
        gridConstraints.anchor = GridBagConstraints.NORTH;
        gridConstraints.gridx = 0;
        gridConstraints.gridy = 1;
        gridConstraints.gridwidth = GridBagConstraints.REMAINDER;
        gridConstraints.gridheight = 1;
        gridbag.setConstraints(_taskMessages.getComponents(),
                               gridConstraints);
        pane.add(_taskMessages.getComponents());

        // Put the slider and label up.
        gridConstraints.anchor = GridBagConstraints.NORTH;
        gridConstraints.gridx = 0;
        gridConstraints.gridy = 2;
        gridConstraints.gridwidth = 1;
        gridConstraints.gridheight = 1;
        gridbag.setConstraints(_levelLabel, gridConstraints);
        pane.add(_levelLabel);

        gridConstraints.anchor = GridBagConstraints.NORTH;
        gridConstraints.gridx = 1;
        gridConstraints.gridy = 2;
        gridConstraints.gridwidth = GridBagConstraints.REMAINDER;
        gridConstraints.gridheight = 1;
        gridbag.setConstraints(_levelSlider, gridConstraints);
        pane.add(_levelSlider);

        // Put the buttons up.
        gridConstraints.anchor = GridBagConstraints.NORTH;
        gridConstraints.gridx = 2;
        gridConstraints.gridy = 3;
        gridConstraints.gridwidth = 1;
        gridbag.setConstraints(_createButton, gridConstraints);
        pane.add(_createButton);

        gridConstraints.gridx = 4;
        gridConstraints.gridy = 3;
        gridbag.setConstraints(_quitButton, gridConstraints);
        pane.add(_quitButton);

        return;
    }

// Member Data.

    // Components.
    private TaskDialog _taskDialog;
    private TaskTable _taskTable;
    private TaskMessages _taskMessages;
    private JSlider _levelSlider;
    private JLabel _levelLabel;
    private JButton _createButton;
    private JButton _quitButton;
}
