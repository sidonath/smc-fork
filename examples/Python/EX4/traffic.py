#!/usr/bin/env python
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
#       Port to Python by Francois Perrad, francois.perrad@gadz.org
#
# traffic --
#
#  Use state machines to do a very simple simulation of stoplights.
#
# RCS ID
# $Id: traffic.py,v 1.2 2008/04/23 12:54:03 fperrad Exp $
#
# CHANGE LOG
# $Log: traffic.py,v $
# Revision 1.2  2008/04/23 12:54:03  fperrad
# + fix #1934497 : remove -w in shebang
#
# Revision 1.1  2005/05/28 17:48:30  cwrapp
# Added Python examples 1 - 4 and 7.
#
#

from Tkinter import *

# Load in the stoplight and vehicles classes.
import Stoplight
import Vehicle

class Top:

	# DisplaySliders --
	#
	#   Display the window which contains the sliders for dynamically
	#   configuring the traffic demo.
	#
	# Arguments:
	#   None.

	def DisplaySliders(self):
		# Immediatly disable the window to prevent it from being
		# selected again.
		self._ConfigButton.configure(state=DISABLED)

		# Put the sliders in a separate window. Create three frames,
		# one for each kind of slider.
		SliderFrame = Toplevel(self._root)
		SliderFrame.title("Traffic Configuration")

		# Put in the slider controls for setting the traffic light times
		# (how long each light stays green or yellow), how often new
		# vehicles appear and how fast vehicles move.
		Scale(SliderFrame,
				from_=5,
				to=20,
				variable=self._NSGreenTime,
				label="North/South green light timer (in seconds)",
				orient=HORIZONTAL,
				tickinterval=5,
				showvalue=None,
				sliderrelief=SUNKEN,
				length=250,
				command=lambda x:self._Stoplight.setLightTimer("NSGreenTimer", int(x)),
		).pack(
				side=TOP,
		)
		Scale(SliderFrame,
				from_=5,
				to=20,
				variable=self._EWGreenTime,
				label="East/West green light timer (in seconds)",
				orient=HORIZONTAL,
				tickinterval=5,
				showvalue=None,
				sliderrelief=SUNKEN,
				length=250,
				command=lambda x:self._Stoplight.setLightTimer("EWGreenTimer", int(x)),
		).pack(
				side=TOP,
		)
		Scale(SliderFrame,
				from_=2,
				to=8,
				variable=self._YellowTime,
				label="Yellow light timer (in seconds)",
				orient=HORIZONTAL,
				tickinterval=2,
				showvalue=None,
				sliderrelief=SUNKEN,
				length=250,
				command=lambda x:self._Stoplight.setLightTimer("YellowTimer", int(x)),
		).pack(
				side=TOP,
		)

		def setAppearanceRate(rate):
			self._AppearanceTimeout = int(rate) * 1000

		Scale(SliderFrame,
				from_=5,
				to=15,
				variable=self._AppearanceRate,
				label="Vehicle appearance rate (in seconds)",
				orient=HORIZONTAL,
				tickinterval=2,
				showvalue=None,
				sliderrelief=SUNKEN,
				length=250,
				command=setAppearanceRate,
		).pack(
				side=TOP,
		)
		Scale(SliderFrame,
				from_=1,
				to=5,
				variable=self._VehicleSpeed,
				label="Vehicle speed (in seconds)",
				orient=HORIZONTAL,
				tickinterval=1,
				showvalue=None,
				sliderrelief=SUNKEN,
				length=250,
				command=lambda x:Vehicle.Vehicle.setSpeed(int(x)),
		).pack(
				side=TOP,
		)

		# When the slider window is destroyed, re-enable the
		# configure button.
		SliderFrame.bind('<Destroy>', lambda x:self._ConfigButton.configure(state=NORMAL))

		SliderFrame.focus()

	# StartDemo --
	#
	#   Start the traffic flowing. Do this by having the
	#   stoplight and vehicle objects start their timers.
	#   Also start the "make vehicles" timer.
	#
	# Arguments:
	#   None.

	def StartDemo(self):
		self._Stoplight.Start()

		# Create four vehicles, one for each direction.
		self.makeVehicles()

		# Every minute, go through the vehicle list and
		# delete those vehicles that have completed their
		# trip.
		self._CollectTimerID = self._root.after(60000, self.garbageCollect)

		# Disable the start button and enable the pause and stop button.
		self._StartButton.configure(state=DISABLED)
		self._PauseButton.configure(state=NORMAL)
		self._StopButton.configure(state=NORMAL)

	# PauseDemo --
	#
	#   Temporarily pause this demo.
	#
	# Arguments:
	#   None.

	def PauseDemo(self):
		self._PauseFlag = True

		# Tell the stop light and vehicles to temporarily
		# stop their timers.
		self._Stoplight.Pause()

		for vehicle in self._VehicleList:
			vehicle.Pause()

		# Stop the vehicle deletion timer.
		if self._CollectTimerID >= 0:
			self._root.after_cancel(self._CollectTimerID)
			self._CollectTimerID = -1

		# Disable the pause button and enable the continue button.
		self._PauseButton.configure(state=DISABLED)
		self._ContinueButton.configure(state=NORMAL)

	# ContinueDemo --
	#
	#   Pick up the demo where you left off.
	#
	# Arguments:
	#   None.

	def ContinueDemo(self):
		self._PauseFlag = False

		# If the vehicle appearance timer expired during the pause,
		# then make some vehicles now.
		if self._AppearanceTimerID == -2:
			self.makeVehicles()

		# Tell the stop light and vehicles to temporarily
		# stop their timers.
		self._Stoplight.Continue()

		for vehicle in self._VehicleList:
			vehicle.Continue()

		# Enable the pause button and disable the continue button.
		self._PauseButton.configure(state=NORMAL)
		self._ContinueButton.configure(state=DISABLED)

	# StopDemo --
	#
	#   Stop the demo and delete all vehicles.
	#
	# Arguments:
	#   None.

	def StopDemo(self):
		self._Stoplight.Stop()

		for vehicle in self._VehicleList:
			vehicle.Stop()
		self._VehicleList = []

		if self._AppearanceTimerID >= 0:
			self._root.after_cancel(self._AppearanceTimerID)
			self._AppearanceTimerID = -1

		if self._CollectTimerID >= 0:
			self._root.after_cancel(self._CollectTimerID)
			self._CollectTimerID = -1

		# Enable the start button and disable all others.
		self._StartButton.configure(state=NORMAL)
		self._PauseButton.configure(state=DISABLED)
		self._ContinueButton.configure(state=DISABLED)
		self._StopButton.configure(state=DISABLED)

	# makeVehicles --
	#
	#   Create four new vehicles to move on the map. When
	#   done, set a timer to make even more later.
	#
	# Arguments:
	#   None.

	def makeVehicles(self):
		self._AppearanceTimerID = -1

		# Don't make vehicles if we are paused. Just remember that
		# the timer expired and call this routine when the demo is
		# continued.
		if self._PauseFlag:
			self._AppearanceTimerID = -2
		else:
			for direction in ('north', 'south', 'east', 'west'):
				vehicle = Vehicle.Vehicle(self._Stoplight, direction, self._Canvas)
				self._VehicleList.append(vehicle)

			# Gentlemen, start your engines.
			for vehicle in self._VehicleList:
				vehicle.Start()

			self._AppearanceTimerID = self._root.after(self._AppearanceTimeout, self.makeVehicles)

	# garbageCollect --
	#
	#   Delete those vehicles that have completed their trip.
	#
	# Arguments:
	#   None.
	#

	def garbageCollect(self):
		self._CollectTimerID = -1

		NewVehicleList = []
		for vehicle in self._VehicleList:
			if vehicle.isDone():
				vehicle.Delete()
			else:
				NewVehicleList.append(vehicle)
		self._VehicleList = NewVehicleList

		# Reset this timer.
		self._CollectTimerID = self._root.after(60000, self.garbageCollect)

	def __init__(self, root):
		self._root = root
		# Default settings.
		self. _VehicleList = []
		self._AppearanceTimerID = -1
		self._AppearanceTimeout = 8000
		self._CollectTimerID = -1
		self._NSGreenTime = IntVar()
		self._NSGreenTime.set(7)
		self._EWGreenTime = IntVar()
		self._EWGreenTime.set(5)
		self._YellowTime = IntVar()
		self._YellowTime.set(2)
		self._AppearanceRate = IntVar()
		self._AppearanceRate.set(8)
		self._VehicleSpeed = IntVar()
		self._VehicleSpeed.set(2)
		self._PauseFlag = False

		# Set up the window in which the stop light demo will appear.
		# Also create two other frames. One will hold the sliders for
		# dynamically configuring the demo and the other buttons to
		# start, pause, continue and quit the demo.
		root.title("Stoplight demo")

		ConfigFrame = Frame(root,
				borderwidth=4,
				relief=FLAT,
				height=15,
				width=250,
		)
		ConfigFrame.pack(
				side=TOP,
				fill=BOTH,
		)
		MainFrame = Frame(root,
				borderwidth=4,
				relief=FLAT,
				height=250,
				width=250,
		)
		MainFrame.pack(
				side=TOP,
				fill=BOTH,
		)
		ButtonFrame = Frame(root,
				borderwidth=4,
				relief=FLAT,
				height=15,
				width=250,
		)
		ButtonFrame.pack(
				side=TOP,
				fill=BOTH,
		)

		# Put a single button in the configure frame which causes the
		# slider window to pop up.
		self._ConfigButton = Button(ConfigFrame,
				text="Configure...",
				command=self.DisplaySliders,
		)
		self._ConfigButton.pack(
				side=RIGHT,
		)

		# Create a canvas in which the stop light graphics will appear.
		self._Canvas = Canvas(MainFrame,
				borderwidth=2,
				background='white',
				relief=RAISED,
				height=250,
				width=250,
		)
		self._Canvas.pack(
				side=TOP,
				fill=BOTH,
		)

		# Create the stoplight and specify which direction initially has
		# the green light.
		self._Stoplight = Stoplight.Stoplight(self._Canvas)

		# Add a button which allows the demo to be started, paused, continued
		# and stopped.
		self._StartButton = Button(ButtonFrame,
				text="Start",
				command=self.StartDemo,
		)
		self._StartButton.pack(
				side=LEFT,
		)
		self._PauseButton = Button(ButtonFrame,
				text="Pause",
				state=DISABLED,
				command=self.PauseDemo,
		)
		self._PauseButton.pack(
				side=LEFT,
		)
		self._ContinueButton = Button(ButtonFrame,
				text="Continue",
				state=DISABLED,
				command=self.ContinueDemo,
		)
		self._ContinueButton.pack(
				side=LEFT,
		)
		self._StopButton = Button(ButtonFrame,
				text="Stop",
				state=DISABLED,
				command=self.StopDemo,
		)
		self._StopButton.pack(
				side=LEFT,
		)

		# Cntl-C stops the demo.
		root.bind('<Control-c>', lambda x: sys.exit(0))


root = Tk()
top = Top(root)
root.mainloop()
