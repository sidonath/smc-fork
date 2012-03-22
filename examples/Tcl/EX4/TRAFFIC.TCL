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
# traffic --
#
#  Use state machines to do a very simple simulation of stoplights.
#
# RCS ID
# $Id: TRAFFIC.TCL,v 1.7 2009/03/27 09:41:47 cwrapp Exp $
#
# CHANGE LOG
# $Log: TRAFFIC.TCL,v $
# Revision 1.7  2009/03/27 09:41:47  cwrapp
# Added F. Perrad changes back in.
#
# Revision 1.6  2008/02/04 12:38:37  fperrad
# fix filename case on linux
#
# Revision 1.5  2005/05/28 18:02:55  cwrapp
# Updated Tcl examples, removed EX6.
#
# Revision 1.1  2005/01/22 13:14:53  charlesr
# Added statemap package location to auto_path.
#
# Revision 1.0  2003/12/14 20:28:22  charlesr
# Initial revision
#

lappend auto_path ../../../lib/Tcl

package require Itcl;
package require statemap;

namespace import ::itcl::*;
namespace import ::statemap::*;

# Load in the stoplight and vehicles classes.
source ./stoplight.tcl;
source ./VEHICLE.TCL;
namespace import ::tcl_ex4::*;

# DEBUG
# Uncomment next line so debug logs can be seen.
# console show;

# DisplaySliders --
#
#   Display the window which contains the sliders for dynamically
#   configuring the traffic demo.
#
# Arguments:
#   None.
#
# Results:
#   ok

proc DisplaySliders {} {
    global ConfigButton SliderFrame Stoplight \
            NSGreenTime EWGreenTime YellowTime \
            AppearanceRate VehicleSpeed;

    # Immediatly disable the window to prevent it from being
    # selected again.
    $ConfigButton configure -state disabled;

    # Put the sliders in a separate window. Create three frames,
    # one for each kind of slider.
    set SliderFrame [toplevel .sliderWin];
    wm title $SliderFrame "Traffic Configuration";

    # Put in the slider controls for setting the traffic light times
    # (how long each light stays green or yellow), how often new
    # vehicles appear and how fast vehicles move.
    set NSGreenSlider \
            [scale $SliderFrame.nsGreenSlider \
            -from 5 \
            -to 20 \
            -variable NSGreenTime \
            -label "North/South green light timer (in seconds)" \
            -orient horizontal \
            -tickinterval 5 \
            -showvalue false \
            -sliderrelief sunken \
            -length 250 \
            -command [list $Stoplight setLightTimer NSGreenTimer]];
    set EWGreenSlider \
            [scale $SliderFrame.ewGreenSlider \
            -from 5 \
            -to 20 \
            -variable EWGreenTime \
            -label "East/West green light timer (in seconds)" \
            -orient horizontal \
            -tickinterval 5 \
            -showvalue false \
            -sliderrelief sunken \
            -length 250 \
            -command [list $Stoplight setLightTimer EWGreenTimer]];
    set YellowSlider \
            [scale $SliderFrame.yellowSlider \
            -from 2 \
            -to 8 \
            -variable YellowTime \
            -label "Yellow light timer (in seconds)" \
            -orient horizontal \
            -tickinterval 2 \
            -showvalue false \
            -sliderrelief sunken \
            -length 250 \
            -command [list $Stoplight setLightTimer YellowTimer]];
    set AppearanceSlider \
            [scale $SliderFrame.vehicleSlider \
            -from 5 \
            -to 15 \
            -variable AppearanceRate \
            -label "Vehicle appearance rate (in seconds)" \
            -orient horizontal \
            -tickinterval 2 \
            -showvalue false \
            -sliderrelief sunken \
            -length 250 \
            -command [list setAppearanceRate]];
    set SpeedSlider \
            [scale $SliderFrame.speedSlider \
            -from 1 \
            -to 5 \
            -variable VehicleSpeed \
            -label "Vehicle speed (in seconds)" \
            -orient horizontal \
            -tickinterval 1 \
            -showvalue false \
            -sliderrelief sunken \
            -length 250 \
            -command [list ::tcl_ex4::Vehicle::setSpeed]];
    pack $NSGreenSlider $EWGreenSlider $YellowSlider -side top;
    pack $AppearanceSlider $SpeedSlider -side top;

    # When the slider window is destroyed, re-enable the
    # configure button.
    bind $SliderFrame <Destroy> {
        if {[string compare "%W" "$SliderFrame"] == 0} {
            $ConfigButton configure -state "normal";
        }
    }

    return -code ok;
}

# StartDemo --
#
#   Start the traffic flowing. Do this by having the
#   stoplight and vehicle objects start their timers.
#   Also start the "make vehicles" timer.
#
# Arguments:
#   None.
#
# Results:
#   ok

proc StartDemo {} {
    global Stoplight CollectTimerID StartButton PauseButton StopButton;

    $Stoplight start;

    # Create four vehicles, one for each direction.
    makeVehicles;

    # Every minute, go through the vehicle list and
    # delete those vehicles that have completed their
    # trip.
    set CollectTimerID [after 60000 [list garbageCollect]];

    # Disable the start button and enable the pause and stop button.
    $StartButton configure -state disabled;
    $PauseButton configure -state normal;
    $StopButton configure -state normal;

    return -code ok;
}

# PauseDemo --
#
#   Temporarily pause this demo.
#
# Arguments:
#   None.
#
# Results:
#   ok

proc PauseDemo {} {
    global Stoplight VehicleList PauseButton ContinueButton PauseFlag \
            CollectTimerID;

    set PauseFlag true;

    # Tell the stop light and vehicles to temporarily
    # stop their timers.
    $Stoplight pause;

    foreach Vehicle $VehicleList {
        $Vehicle pause;
    }

    # Stop the vehicle deletion timer.
    if {$CollectTimerID >= 0} {
        after cancel CollectTimerID;
        set CollectTimerID -1;
    }

    # Disable the pause button and enable the continue button.
    $PauseButton configure -state disabled;
    $ContinueButton configure -state normal;

    return -code ok;
}

# ContinueDemo --
#
#   Pick up the demo where you left off.
#
# Arguments:
#   None.
#
# Results:
#   ok

proc ContinueDemo {} {
    global Stoplight VehicleList PauseButton ContinueButton PauseFlag \
            AppearanceTimerID;

    set PauseFlag false;

    # If the vehicle appearance timer expired during the pause,
    # then make some vehicles now.
    if {$AppearanceTimerID == -2} {
        makeVehicles;
    }

    # Tell the stop light and vehicles to temporarily
    # stop their timers.
    $Stoplight continue;

    foreach Vehicle $VehicleList {
        $Vehicle continue;
    }

    # Enable the pause button and disable the continue button.
    $PauseButton configure -state normal;
    $ContinueButton configure -state disabled;

    return -code ok;
}

# StopDemo --
#
#   Stop the demo and delete all vehicles.
#
# Arguments:
#   None.
#
# Results:
#   ok

proc StopDemo {} {
    global Stoplight VehicleList AppearanceTimerID CollectTimerID \
            StartButton PauseButton ContinueButton StopButton \
            CollectTimerID;

    $Stoplight stop;

    foreach Vehicle $VehicleList {
        $Vehicle stop;
        delete object $Vehicle;
    }
    set VehicleList {};

    if {$AppearanceTimerID >= 0} {
        after cancel $AppearanceTimerID;
        set AppearanceTimerID -1;
    }

    if {$CollectTimerID >= 0} {
        after cancel CollectTimerID;
        set CollectTimerID -1;
    }

    # Enable the start button and disable all others.
    $StartButton configure -state normal;
    $PauseButton configure -state disabled;
    $ContinueButton configure -state disabled;
    $StopButton configure -state disabled;

    return -code ok;
}

# makeVehicles --
#
#   Create four new vehicles to move on the map. When
#   done, set a timer to make even more later.
#
# Arguments:
#   None.
#
# Results:
#   ok

proc makeVehicles {} {
    global Stoplight Canvas VehicleList AppearanceTimerID \
            AppearanceTimeout PauseFlag;

    set AppearanceTimerID -1;

    # Don't make vehicles if we are paused. Just remember that
    # the timer expired and call this routine when the demo is
    # continued.
    if {$PauseFlag == "true"} {
        set AppearanceTimerID -2;
    } else {
        lappend VehicleList [::tcl_ex4::Vehicle #auto $Stoplight north $Canvas];
        lappend VehicleList [::tcl_ex4::Vehicle #auto $Stoplight south $Canvas];
        lappend VehicleList [::tcl_ex4::Vehicle #auto $Stoplight east $Canvas];
        lappend VehicleList [::tcl_ex4::Vehicle #auto $Stoplight west $Canvas];
        
        # Gentlemen, start your engines.
        foreach Vehicle $VehicleList {
            $Vehicle start;
        }

        set AppearanceTimerID [after $AppearanceTimeout [list makeVehicles]];
    }

    return -code ok;
}

# setAppearanceRate --
#
#   Set the rate at which vehicles appear.
#
# Arguments:
#   rate    In seconds. Convert to milliseconds.
#
# Results:
#   ok

proc setAppearanceRate {rate} {
    global AppearanceTimeout;

    set AppearanceTimeout [expr $rate * 1000];

    return -code ok;
}

# garbageCollect --
#
#   Delete those vehicles that have completed their trip.
#
# Arguments:
#   None.
#
# Results:
#   ok

proc garbageCollect {} {
    global VehicleList CollectTimerID;

    set CollectTimerID -1;

    set NewVehicleList {};
    foreach Vehicle $VehicleList {
        if {[$Vehicle isDone] == "true"} {
            puts "Deleting vehicle $Vehicle";
            delete object $Vehicle;
        } else {
            lappend NewVehicleList $Vehicle;
        }
    }

    set VehicleList $NewVehicleList;

    # Reset this timer.
    set CollectTimerID [after 60000 [list garbageCollect]];

    return -code ok;
}

# Default settings.
set VehicleList {};
set AppearanceTimerID -1;
set AppearanceTimeout 8000;
set NSGreenTime 7;
set EWGreenTime 5;
set YellowTime 2;
set AppearanceRate 8;
set VehicleSpeed 2;
set PauseFlag false;

# Set up the window in which the stop light demo will appear.
# Also create two other frames. One will hold the sliders for
# dynamically configuring the demo and the other buttons to
# start, pause, continue and quit the demo.
wm title . "Stoplight demo";
set ConfigFrame [frame .configure -borderwidth 4 \
        -relief flat \
        -height 15 \
        -width 250];
set MainFrame [frame .main -borderwidth 4 \
        -relief flat \
        -height 250 \
        -width 250];
set ButtonFrame [frame .buttons -borderwidth 4 \
        -relief flat \
        -height 15 \
        -width 250];
pack $ConfigFrame $MainFrame $ButtonFrame -side top -fill both;

# Put a single button in the configure frame which causes the
# slider window to pop up.
set ConfigButton [button $ConfigFrame.configButton -text "Configure..." \
        -command "DisplaySliders"];
pack $ConfigButton -side right;

# Create a canvas in which the stop light graphics will appear.
set Canvas [canvas $MainFrame.graphicFrame -borderwidth 2 \
        -background white \
        -relief raised \
        -height 250 \
        -width 250];
pack $Canvas -side top -fill both;

# Create the stoplight and specify which direction initially has
# the green light.
set Stoplight [::tcl_ex4::Stoplight TheLight $Canvas];

# Add a button which allows the demo to be started, paused, continued
# and stopped.
set StartButton [button $ButtonFrame.startButton -text Start \
        -command "StartDemo"];
set PauseButton [button $ButtonFrame.pauseButton -text Pause \
        -state disabled \
        -command "PauseDemo"];
set ContinueButton [button $ButtonFrame.continueButton -text Continue \
        -state disabled \
        -command "ContinueDemo"];
set StopButton [button $ButtonFrame.quitButton -text Stop \
        -state disabled \
        -command "StopDemo"];
pack $StartButton $PauseButton $ContinueButton $StopButton -side left;

# Cntl-C stops the demo as well.
bind $MainFrame <Control-c> "exit 0";
focus $MainFrame;

# Delete the vehicles and the vehicle creation timer before dying.
bind . <Destroy> {
    if {"%W" == "."} {
        foreach Vehicle $VehicleList {
            delete object $Vehicle;
        }
        set VehicleList {};

        if {$AppearanceTimerID >= 0} {
            after cancel $AppearanceTimerID;
            set AppearanceTimerID -1;
        }

        if {$CollectTimerID >= 0} {
            after cancel CollectTimerID;
            set CollectTimerID -1;
        }
    }
}