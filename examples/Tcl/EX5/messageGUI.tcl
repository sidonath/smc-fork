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
# MessageGUI --
#
#   Displays system messages on the given canvas IF the message
#   level passes the filter.
#
# RCS ID
# $Id: messageGUI.tcl,v 1.4 2005/05/28 18:02:56 cwrapp Exp $
#
# CHANGE LOG
# $Log: messageGUI.tcl,v $
# Revision 1.4  2005/05/28 18:02:56  cwrapp
# Updated Tcl examples, removed EX6.
#
# Revision 1.0  2003/12/14 20:32:32  charlesr
# Initial revision
#

class MessageGUI {

# Member data.
    # Put messages on this canvas.
    private variable _canvas;

    # The current acceptable message level.
    private variable _level;

    # Put the next message on this line.
    private variable _currentLine;

    # Use this array to match colors with levels.
    private variable _levelColor;

    # Constants
    private common _initialXOffset 4;
    private common _initialYOffset 0;
    private common _rowSeparation 2;
    private common _colSeparation 2;
    private common _dateX1 $_initialXOffset;
    private common _dateLength 70;
    private common _timeX1 [expr $_dateX1 + $_dateLength + $_colSeparation];
    private common _timeLength 55;
    private common _nameX1 [expr $_timeX1 + $_timeLength + $_colSeparation];
    private common _nameLength 115;
    private common _levelX1 [expr $_nameX1 + $_nameLength + $_colSeparation];
    private common _levelLength 25;
    private common _messageX1 [expr $_levelX1 + $_levelLength + $_colSeparation];
    private common _rowHeight 15;
    private common _rowPaddedHeight [expr $_rowHeight + $_rowSeparation];

    # The following need the canvas object.
    private common _canvasXMax;
    private common _canvasYMax;
    private common _screenXMax;
    private common _screenYMax;
    private common _maxX1;
    private common _maxY1;

# Member methods.
    constructor {canvas level} {
        set _canvas $canvas;
        set _level $level;
        set _currentLine 0;

        set _canvasXMax [lindex [$_canvas cget -scrollregion] 2];
        set _canvasYMax [lindex [$_canvas cget -scrollregion] 3];
        set _screenXMax [$_canvas cget -width];
        set _screenYMax [$_canvas cget -height];
        set _maxX1 $_canvasXMax;
        set _maxY1 [expr $_canvasYMax - $_rowPaddedHeight];

        # Set up the array for mapping display colors to levels.
        set _levelColor(0) red;
        set _levelColor(1) orange;
        set _levelColor(2) goldenrod;
        set _levelColor(3) blue;
    }

    destructor {}

    # getLevel --
    #
    #   Return the current filter level.
    #
    # Arguments:
    #   None.
    #
    # Results:
    #   Returns the message filter level.

    public method getLevel {} {
        return -code ok $_level;
    }

    # setLevel --
    #
    #   Update the message filter level.
    #
    # Arguments:
    #   level   The new filter level.
    #
    # Results:
    #   None.

    public method setLevel {level} {
        set _level $level;
        return -code ok;
    }

    # postMessage --
    #
    #   If the message's level passes the filter, then post
    #   the message along with the posting object's name and
    #   a timestamp.
    #
    # Arguments:
    #   level     the message's level of importance.
    #   name      The posting object's name.
    #   message   The message to be displayed.
    #
    # Results:
    #   None.

    public method postMessage {level name message} {
        if {$level <= $_level} {
            # Generate the display text.
            set CurrTime [clock seconds];
            set Date [clock format $CurrTime -format "%d/%m/%Y"];
            set Time [clock format $CurrTime -format "%H:%M:%S"];

            # Figure out what text tag goes with this message.
            if {$level > 3} {
                set Color black;
            } else {
                set Color $_levelColor($level);
            }

            # If this is the very first message, then give it
            # the first tag.
            if {$_currentLine == 0} {
                set TagList [list first];
            } else {
                set TagList [list rest];
            }
            # Figure out where the message goes on the display
            set Y1 [expr $_initialYOffset + \
                       [expr $_currentLine * $_rowPaddedHeight]];

            # If the canvas is filled up, then start shoving
            # messages off the top.
            if {$Y1 > $_canvasYMax} {
                $_canvas delete first;
                $_canvas move rest 0 [expr $_rowPaddedHeight * -1];

                # Now re-tag the new top line. Remove its rest
                # tag and replace it with first.
                set ItemList [$_canvas find enclosed \
                        [expr $_initialXOffset - $_colSeparation] \
                        [expr $_initialYOffset - $_rowSeparation] \
                        [expr $_canvasXMax + $_colSeparation] \
                        [expr $_initialYOffset + $_rowPaddedHeight + $_rowSeparation]];
                foreach Item $ItemList {
                    $_canvas dtag $Item rest;
                    $_canvas addtag first withtag $Item;
                }
                
                set Y1 $_maxY1;
            } elseif {$Y1 > [expr [$_canvas canvasy $_screenYMax] - $_rowHeight]} {
                # Scroll up one line and put the new message at
                # the bottom of the canvas.
                $_canvas yview scroll 1 units;
            }

            # Put the new line up on display.
            $_canvas create text \
                    $_dateX1 \
                    $Y1 \
                    -text $Date \
                    -anchor nw \
                    -fill $Color \
                    -justify left \
                    -tag $TagList;

            $_canvas create text \
                    $_timeX1 \
                    $Y1 \
                    -text $Time \
                    -anchor nw \
                    -fill $Color \
                    -justify left \
                    -tag $TagList;

            $_canvas create text \
                    $_nameX1 \
                    $Y1 \
                    -text [string range $name 0 14] \
                    -anchor nw \
                    -fill $Color \
                    -justify left \
                    -tag $TagList;

            $_canvas create text \
                    $_levelX1 \
                    $Y1 \
                    -text $level \
                    -anchor nw \
                    -fill $Color \
                    -justify right \
                    -tag $TagList;

            $_canvas create text \
                    $_messageX1 \
                    $Y1 \
                    -text $message \
                    -anchor nw \
                    -fill $Color \
                    -justify left \
                    -tag $TagList;

            incr _currentLine;
        }

        return -code ok;
    }
}
