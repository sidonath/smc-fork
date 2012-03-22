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
# Vehicle --
#
#  Draws a generic vehicle on the map (a black square) which
#  moves in straight lines along the road and obeys the stop light.
#
# RCS ID
# $Id: Vehicle.py,v 1.2 2009/04/19 14:39:48 cwrapp Exp $
#
# CHANGE LOG
# $Log: Vehicle.py,v $
# Revision 1.2  2009/04/19 14:39:48  cwrapp
# Added call to enterStartState before issuing first FSM transition.
#
# Revision 1.1  2005/05/28 17:48:30  cwrapp
# Added Python examples 1 - 4 and 7.
#
#

from Tkinter import *

import Vehicle_sm

class Vehicle:

	_speed = 2

	def __init__(self, stoplight, direction, canvas):
		self._fsm = Vehicle_sm.Vehicle_sm(self)

		# The canvas to draw on and the direction this vehicle is
		# moving.
		self._canvas = canvas
		self._direction = direction

		# The stoplight object is responsible knowing the road
		# layout. Ask it for all relevant information.
		self._stoplight = stoplight

		# This vehicle is initially at the road's outside edge.
		# Figure out the road's length.
		XLength = stoplight.getRoadLengthX()
		YLength = stoplight.getRoadLengthY()
		LaneWidth = stoplight.getRoadWidth() / 2

		# The vehicle is 12 pixels x 12 pixels.
		self._vehicleSize = 6

		# A 3 pixel separation is to be maintained between vehicles.
		self._vehicleSeparation = 3

		# How far away the vehicle is from the curb.
		CurbOffset = (LaneWidth - self._vehicleSize) / 2

		# The vehicle's current canvas location. This is the
		# square's upper left hand corner.
		if      direction == 'north':
			self._xpos = (XLength / 2) + CurbOffset
			self._ypos = YLength - self._vehicleSize
		elif direction == 'south':
			self._xpos = (XLength / 2) - LaneWidth + CurbOffset
			self._ypos = 0
		elif direction == 'east':
			self._xpos = 0
			self._ypos = (YLength / 2) + CurbOffset
		elif direction == 'west':
			self._xpos = XLength - self._vehicleSize
			self._ypos = (YLength / 2) - LaneWidth + CurbOffset

		# Put the vehicle on display.
		self._canvasID = canvas.create_rectangle(
				self._xpos,
				self._ypos,
				self._xpos + self._vehicleSize,
				self._ypos + self._vehicleSize,
				fill='black',
				outline='white',
		)

		# Move this vehicle along at near movie-refresh rate.
		self._redrawRate = 1000 / 60

		# Store the after's timer ID here.
		self._timerID = -1

		# Set this flag to true when the vehicle has
		# completed its trip.
		self._isDoneFlag = False

		# Uncomment to see debug output.
		#self._fsm.setDebugFlag(True)

	def Delete(self):
		if self._timerID >= 0:
			self._canvas.after_cancel(self._timerID)
			self._timerID = -1
		self._canvas.delete(self._canvasID)

	# timeout --
	#
	#   If the vehicle has driven off the canvas, then
	#   delete the vehicle.
	#   Check if the vehicle is at the intersection and the
	#   light is either yellow or red. If yes, then issue a
	#   "LightRed" transition. If all is go, then keep on
	#   truckin.
	#
	# Arugments:
	#   None.

	def timeout(self):
		self._timerID = -1
		if self.OffCanvas():
			self._fsm.TripDone()
		elif self.AtIntersection() and self.getLight() != 'green':
			self._fsm.LightRed()
		else:
			self._fsm.KeepGoing()

	def getLight(self):
		return self._stoplight.getLight(self._direction)

	# lightGreen --
	#
	#   The light has turned green. Time to get moving again.
	#
	# Arguments:
	#   None

	def lightGreen(self):
		self._fsm.LightGreen()

	# setSpeed --
	#
	#   Set speed for all vehicles.
	#
	# Arguments:
	#   speed   In pixels.

	def setSpeed(klass, speed):
		if speed < 1 or speed > 10:
			print "Invalid speed (%d).\n" % speed
		else:
			klass._speed = speed

	setSpeed = classmethod(setSpeed)

	# isDone --
	#
	#   Has this vehicle completed its trip?
	#
	# Arguments:
	#   None.
	#
	# Results:
	#   Returns true if the trip is done and false
	#   otherwise.

	def isDone(self):
		return self._isDoneFlag

	# start --
	#
	#   Start this vehicle running.
	#
	# Arguments:
	#   None.

	def Start(self):
		self._fsm.enterStartState()
		self._fsm.Start()

	# pause --
	#
	#   Pause this vehicles' running.
	#
	# Arguments:
	#   None.

	def Pause(self):
		self._fsm.Pause()

	# continue --
	#
	#   Continue this vehicles' running.
	#
	# Arguments:
	#   None.

	def Continue(self):
		self._fsm.Continue()

	# stop --
	#
	#   Stop this vehicles' running.
	#
	# Arguments:
	#   None.
	#

	def Stop(self):
		self._fsm.Stop()
		self.Delete()

	# State Machine Actions
	#
	# The following methods are called by the state machine.

	# SetTimer --
	#
	#   Set the timer for the next move.
	#
	# Arguments:
	#   None.

	def SetTimer(self):
		self._timerID = self._canvas.after(self._redrawRate, self.timeout)

	# StopTimer --
	#
	#   Stop the vehicle's timer.
	#
	# Arguments:
	#   None.

	def StopTimer(self):
		if self._timerID >= 0:
			self._canvas.after_cancel(self._timerID)
			self._timerID = -1

	# Move --
	#
	#   1. Calculate the vehicle's new position.
	#   2. Remove the vehicle from the canvas.
	#   3. Draw the vehicles new position.
	#
	# Arguments:
	#   None.
	#
	# Results:
	#   None returned. Side affect of redrawing vehicle.

	def Move(self):
		if      self._direction == 'north':
			Xmove = 0
			Ymove = - self._speed
		elif self._direction == 'south':
			Xmove = 0
			Ymove = self._speed
		elif self._direction == 'east':
			Xmove = self._speed
			Ymove = 0
		elif self._direction == 'west':
			Xmove = - self._speed
			Ymove = 0

		self._canvas.move(self._canvasID, Xmove, Ymove)

		self._xpos += Xmove
		self._ypos += Ymove

	# RegisterWithLight --
	#
	#   When the light turns green, it will inform us.
	#
	# Arguments:
	#   None.

	def RegisterWithLight(self):
		self._stoplight.registerVehicle(self, self._direction)

	# SelfDestruct --
	#
	#   Remove the vehicle from the canvas.
	#
	# Arguments:
	#   None.

	def SelfDestruct(self):
		self._canvas.delete(self._canvasID)
		self._canvasID = -1
		self._isDoneFlag = True

	# OffCanvas --
	#
	#   Figure out if the vehicle has driven off the map.
	#
	# Arguments:
	#   None.
	#
	# Results:
	#   Returns true if the vehicle is off the map; otherwise
	#   false.

	def OffCanvas(self):
		if      self._direction == 'north':
			return (self._ypos - self._speed) <= 0
		elif self._direction == 'south':
			YLength = self._stoplight.getRoadLengthY()
			return (self._ypos + self._speed) >= YLength
		elif self._direction == 'east':
			XLength = self._stoplight.getRoadLengthX()
			return (self._xpos + self._speed) >= XLength
		elif self._direction == 'west':
			return (self._xpos - self._speed) <= 0

	# AtIntersection --
	#
	#   Figure out whether this vehicile is at the intersection
	#   or not.
	#
	# Arguments:
	#   None.
	#
	# Results:
	#   Returns true if the vehicle is at the intersection;
	#   otherwise, false.

	def AtIntersection(self):
		# The vehicle is not at the intersection until proven
		# otherwise.
		Retval = False

		XLength = self._stoplight.getRoadLengthX()
		YLength = self._stoplight.getRoadLengthY()
		LaneWidth = self._stoplight.getRoadWidth() / 2

		# Calculate the intersections coordinates based on
		# the vehicle's direction. Then calculate where the
		# vehicle will end up this move. If the vehicle will
		# move beyond the intersection stop line, then the
		# vehicle is at the intersection.
		#
		# Also take into account the vehicles already waiting
		# at the intersection.
		#
		# By the way, once the vehicle moves past the intersection,
		# ignore the light.
		NumVehicles = self._stoplight.getQueueSize(self._direction)
		LenVehicles = (self._vehicleSize + self._vehicleSeparation) * NumVehicles
		if      self._direction == 'north':
			YIntersection = (YLength / 2) + LaneWidth + (self._vehicleSize / 2) + LenVehicles
			Retval = (self._ypos > YIntersection) and (self._ypos - self._speed <= YIntersection)
		elif self._direction == 'south':
			YIntersection = (YLength / 2) - LaneWidth - (self._vehicleSize / 2) - LenVehicles
			Retval = (self._ypos < YIntersection) and (self._ypos + self._speed >= YIntersection)
		elif self._direction == 'east':
			XIntersection = (XLength / 2) - LaneWidth - (self._vehicleSize / 2) - LenVehicles
			Retval = (self._xpos < XIntersection) and (self._xpos + self._speed >= XIntersection)
		elif self._direction == 'west':
			XIntersection = (XLength / 2) + LaneWidth + (self._vehicleSize / 2) + LenVehicles
			Retval = (self._xpos > XIntersection) and (self._xpos - self._speed <= XIntersection)
		return Retval
