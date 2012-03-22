#!/usr/bin/env ruby
# -*- tab-width: 4; -*-

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
#       Port to Ruby by Francois Perrad, francois.perrad@gadz.org
#
# traffic --
#
#  Use state machines to do a very simple simulation of stoplights.
#
# RCS ID
# $Id: traffic.rb,v 1.2 2008/04/23 12:53:29 fperrad Exp $
#
# CHANGE LOG
# $Log: traffic.rb,v $
# Revision 1.2  2008/04/23 12:53:29  fperrad
# + fix #1934497 : remove -w in shebang
#
# Revision 1.1  2005/06/16 17:52:03  fperrad
# Added Ruby examples 1 - 4 and 7.
#
#

require 'tk'

# Load in the stoplight and vehicles classes.
require 'Stoplight'
require 'Vehicle'

class Top

	# DisplaySliders --
	#
	#   Display the window which contains the sliders for dynamically
	#   configuring the traffic demo.
	#
	# Arguments:
	#   None.

	def displaySliders()
		# Immediatly disable the window to prevent it from being
		# selected again.
		@_ConfigButton.configure('state' => 'disabled')

		# Put the sliders in a separate window. Create three frames,
		# one for each kind of slider.
		sliderFrame = TkToplevel.new(@_root)
		sliderFrame.title("Traffic Configuration")

		# Put in the slider controls for setting the traffic light times
		# (how long each light stays green or yellow), how often new
		# vehicles appear and how fast vehicles move.
		TkScale.new(sliderFrame,
				'from' => 5,
				'to' => 20,
				'variable' => @_NSGreenTime,
				'label' => "North/South green light timer (in seconds)",
				'orient' => 'horizontal',
				'tickinterval' => 5,
				'showvalue' => false,
				'sliderrelief' => 'sunken',
				'length' => 250,
				'command' => proc { |x| @_Stoplight.setLightTimer("NSGreenTimer", x.to_i) }
		).pack(
				'side' => 'top'
		)
		TkScale.new(sliderFrame,
				'from' => 5,
				'to' => 20,
				'variable' => @_EWGreenTime,
				'label' => "East/West green light timer (in seconds)",
				'orient' => 'horizontal',
				'tickinterval' => 5,
				'showvalue' => false,
				'sliderrelief' => 'sunken',
				'length' => 250,
				'command' => proc { |x| @_Stoplight.setLightTimer("EWGreenTimer", x.to_i) }
		).pack(
				'side' => 'top'
		)
		TkScale.new(sliderFrame,
				'from' => 2,
				'to' => 8,
				'variable' => @_YellowTime,
				'label' => "Yellow light timer (in seconds)",
				'orient' => 'horizontal',
				'tickinterval' => 1,
				'showvalue' => false,
				'sliderrelief' => 'sunken',
				'length' => 250,
				'command' => proc { |x| @_Stoplight.setLightTimer("YellowTimer", x.to_i) }
		).pack(
				'side' => 'top'
		)
		TkScale.new(sliderFrame,
				'from' => 5,
				'to' => 15,
				'variable' => @_AppearanceRate,
				'label' => "Vehicle appearance rate (in seconds)",
				'orient' => 'horizontal',
				'tickinterval' => 2,
				'showvalue' => false,
				'sliderrelief' => 'sunken',
				'length' => 250,
				'command' => proc { |rate| @_AppearanceTimeout = rate.to_i * 1000 }
		).pack(
				'side' => 'top'
		)
		TkScale.new(sliderFrame,
				'from' => 1,
				'to' => 5,
				'variable' => @_VehicleSpeed,
				'label' => "Vehicle speed (in seconds)",
				'orient' => 'horizontal',
				'tickinterval' => 1,
				'showvalue' => false,
				'sliderrelief' => 'sunken',
				'length' => 250,
				'command' => proc { |x| Vehicle.setSpeed(x.to_i) }
		).pack(
				'side' => 'top'
		)

		# When the slider window is destroyed, re-enable the
		# configure button.
		sliderFrame.bind('Destroy') { @_ConfigButton.configure('state' => 'normal') }

		sliderFrame.focus
	end

	# StartDemo --
	#
	#   Start the traffic flowing. Do this by having the
	#   stoplight and vehicle objects start their timers.
	#   Also start the "make vehicles" timer.
	#
	# Arguments:
	#   None.

	def startDemo()
		@_Stoplight.Start

		# Create four vehicles, one for each direction.
		makeVehicles

		# Every minute, go through the vehicle list and
		# delete those vehicles that have completed their
		# trip.
		@_CollectTimerID = TkAfter.new(60000, 1, proc { garbageCollect } )
		@_CollectTimerID.start

		# Disable the start button and enable the pause and stop button.
		@_StartButton.configure('state' => 'disabled')
		@_PauseButton.configure('state' => 'normal')
		@_StopButton.configure('state' => 'normal')
	end

	# PauseDemo --
	#
	#   Temporarily pause this demo.
	#
	# Arguments:
	#   None.

	def pauseDemo()
		@_PauseFlag = true

		# Tell the stop light and vehicles to temporarily
		# stop their timers.
		@_Stoplight.Pause

		for vehicle in @_VehicleList do
			vehicle.Pause
		end

		# Stop the vehicle deletion timer.
		unless @_CollectTimerID.nil? then
			@_CollectTimerID.cancel
			@_CollectTimerID = nil
		end

		# Disable the pause button and enable the continue button.
		@_PauseButton.configure('state' => 'disabled')
		@_ContinueButton.configure('state' => 'normal')
	end

	# ContinueDemo --
	#
	#   Pick up the demo where you left off.
	#
	# Arguments:
	#   None.

	def continueDemo()
		@_PauseFlag = false

		# If the vehicle appearance timer expired during the pause,
		# then make some vehicles now.
		if @_AppearanceTimerID == -2 then
			makeVehicles
		end

		# Tell the stop light and vehicles to temporarily
		# stop their timers.
		@_Stoplight.Continue

		for vehicle in @_VehicleList do
			vehicle.Continue
		end

		# Enable the pause button and disable the continue button.
		@_PauseButton.configure('state' => 'normal')
		@_ContinueButton.configure('state' => 'disabled')
	end

	# StopDemo --
	#
	#   Stop the demo and delete all vehicles.
	#
	# Arguments:
	#   None.

	def stopDemo()
		@_Stoplight.Stop

		for vehicle in @_VehicleList do
			vehicle.Stop
		end
		@_VehicleList = []

		unless @_AppearanceTimerID.nil? then
			@_AppearanceTimerID.cancel
			@_AppearanceTimerID = nil
		end

		unless @_CollectTimerID.nil? then
			@_CollectTimerID.cancel
			@_CollectTimerID = nil
		end

		# Enable the start button and disable all others.
		@_StartButton.configure('state' => 'normal')
		@_PauseButton.configure('state' => 'disabled')
		@_ContinueButton.configure('state' => 'disabled')
		@_StopButton.configure('state' => 'disabled')
	end

	# makeVehicles --
	#
	#   Create four new vehicles to move on the map. When
	#   done, set a timer to make even more later.
	#
	# Arguments:
	#   None.

	def makeVehicles()
		@_AppearanceTimerID = nil

		# Don't make vehicles if we are paused. Just remember that
		# the timer expired and call this routine when the demo is
		# continued.
		if @_PauseFlag then
			@_AppearanceTimerID = -2
		else
			for direction in ['north', 'south', 'east', 'west'] do
				vehicle = Vehicle::new(@_Stoplight, direction, @_Canvas)
				@_VehicleList.push(vehicle)
			end

			# Gentlemen, start your engines.
			for vehicle in @_VehicleList do
				vehicle.Start
			end

			@_AppearanceTimerID = TkAfter.new(@_AppearanceTimeout, 1, proc { makeVehicles } )
			@_AppearanceTimerID.start
		end
	end

	# garbageCollect --
	#
	#   Delete those vehicles that have completed their trip.
	#
	# Arguments:
	#   None.
	#

	def garbageCollect()
		@_CollectTimerID = nil

		newVehicleList = []
		for vehicle in @_VehicleList do
			if vehicle.isDone then
				vehicle.Delete
			else
				newVehicleList.push(vehicle)
			end
		end
		@_VehicleList = newVehicleList

		# Reset this timer.
		@_CollectTimerID = TkAfter.new(60000, 1, proc { garbageCollect } )
		@_CollectTimerID.start
	end

	def initialize(root)
		@_root = root
		# Default settings.
		@_VehicleList = []
		@_AppearanceTimerID = nil
		@_AppearanceTimeout = 8000
		@_CollectTimerID = nil
		@_NSGreenTime = TkVariable.new
		@_NSGreenTime.value = 7
		@_EWGreenTime = TkVariable.new
		@_EWGreenTime.value = 5
		@_YellowTime = TkVariable.new
		@_YellowTime.value = 2
		@_AppearanceRate = TkVariable.new
		@_AppearanceRate.value = 8
		@_VehicleSpeed = TkVariable.new
		@_VehicleSpeed.value = 2
		@_PauseFlag = false

		# Set up the window in which the stop light demo will appear.
		# Also create two other frames. One will hold the sliders for
		# dynamically configuring the demo and the other buttons to
		# start, pause, continue and quit the demo.
		root.title("Stoplight demo")

		configFrame = TkFrame.new(root,
				'borderwidth' => 4,
				'relief' => 'flat',
				'height' => 15,
				'width' => 250
		)
		configFrame.pack(
				'side' => 'top',
				'fill' => 'both'
		)
		mainFrame = TkFrame.new(root,
				'borderwidth' => 4,
				'relief' => 'flat',
				'height' => 250,
				'width' => 250
		)
		mainFrame.pack(
				'side' => 'top',
				'fill' => 'both'
		)
		buttonFrame = TkFrame.new(root,
				'borderwidth' => 4,
				'relief' => 'flat',
				'height' => 15,
				'width' => 250
		)
		buttonFrame.pack(
				'side' => 'top',
				'fill' => 'both'
		)

		# Put a single button in the configure frame which causes the
		# slider window to pop up.
		@_ConfigButton = TkButton.new(configFrame,
				'text' => "Configure...",
				'command' => proc { displaySliders }
		)
		@_ConfigButton.pack(
				'side' => 'right'
		)

		# Create a canvas in which the stop light graphics will appear.
		@_Canvas = TkCanvas.new(mainFrame,
				'borderwidth' => 2,
				'background' => 'white',
				'relief' => 'raised',
				'height' => 250,
				'width' => 250
		)
		@_Canvas.pack(
				'side' => 'top',
				'fill' => 'both'
		)

		# Create the stoplight and specify which direction initially has
		# the green light.
		@_Stoplight = Stoplight::new(@_Canvas)

		# Add a button which allows the demo to be started, paused, continued
		# and stopped.
		@_StartButton = TkButton.new(buttonFrame,
				'text' => "Start",
				'command' => proc { startDemo }
		)
		@_StartButton.pack(
				'side' => 'left'
		)
		@_PauseButton = TkButton.new(buttonFrame,
				'text' => "Pause",
				'state' => 'disabled',
				'command' => proc { pauseDemo }
		)
		@_PauseButton.pack(
				'side' => 'left'
		)
		@_ContinueButton = TkButton.new(buttonFrame,
				'text' => "Continue",
				'state' => 'disabled',
				'command' => proc { continueDemo }
		)
		@_ContinueButton.pack(
				'side' => 'left'
		)
		@_StopButton = TkButton.new(buttonFrame,
				'text' => "Stop",
				'state' => 'disabled',
				'command' => proc { stopDemo }
		)
		@_StopButton.pack(
				'side' => 'left'
		)

		# Cntl-C stops the demo.
		root.bind('Control-c') { exit }
	end

end

root = TkRoot.new
top = Top.new(root)
Tk.mainloop
