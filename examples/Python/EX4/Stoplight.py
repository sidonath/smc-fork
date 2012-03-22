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
# Stoplight --
#
#  When a timer goes off, change the light's color as per the
#  state machine.
#
# RCS ID
# $Id: Stoplight.py,v 1.2 2009/04/19 14:39:48 cwrapp Exp $
#
# CHANGE LOG
# $Log: Stoplight.py,v $
# Revision 1.2  2009/04/19 14:39:48  cwrapp
# Added call to enterStartState before issuing first FSM transition.
#
# Revision 1.1  2005/05/28 17:48:29  cwrapp
# Added Python examples 1 - 4 and 7.
#
#

import Stoplight_sm

class Stoplight:

	def __init__(self, canvas):
		self._canvas = canvas
		# Create the stop light's state machine.
		self._fsm = Stoplight_sm.Stoplight_sm(self)

		self._east_light = dict()
		self._west_light = dict()
		self._north_light = dict()
		self._south_light = dict()
		self._roadWidth = 38
		self._lightDiameter = 6
		self._lightSpace = 2

		# Set the light height and width.
		self._lightWidth = self._lightDiameter + self._lightSpace * 2
		self._lightHeight = self._lightDiameter * 3 + self._lightSpace * 4

		self._northVehicleList = []
		self._southVehicleList = []
		self._eastVehicleList = []
		self._westVehicleList = []

		# Create the stoplight GUI. Draw the roads.
		self.DrawRoads()

		# Draw the stoplights.
		self.DrawLights()

		# Set each light timer.
		self._timeouts = {
				'NSGreenTimer': 7000,
				'EWGreenTimer': 5000,
				'YellowTimer': 2000,
		}

		self._timerID = -1

		# Uncomment to see debug output.
		#self._fsm.setDebugFlag(True)

	# getRoadLengthX --
	#
	#   Return the road's length in X direction.
	#
	# Arguments:
	#   None.
	#
	# Results:
	#   Pixel length of road in X direction.

	def getRoadLengthX(self):
		return int(self._canvas.cget('width'))

	# getRoadLengthY --
	#
	#   Return the road's length in Y direction in pixels.
	#
	# Arguments:
	#   None.
	#
	# Results:
	#   Pixel length of road in Y direction.

	def getRoadLengthY(self):
		return int(self._canvas.cget('height'))

	# getRoadWidth --
	#
	#   Return road's width in pixels.
	#
	# Arguments:
	#   None.
	#
	# Results:
	#   Road's width in pixels.

	def getRoadWidth(self):
		return self._roadWidth

	# getLight --
	#
	#   Return a specified stop lights color.
	#
	# Arguments:
	#   direction   Must be either north, south east or west.
	#
	# Results:
	#   Returns the color for that direction.

	def getLight(self, direction):
		cv = self._canvas

		# The direction represents which way the vehicle
		# is facing. This is the opposite direction in which
		# the light is facing.
		if      direction == 'north':
			RedLight = cv.itemcget(self._south_light['RED'], 'fill')
			YellowLight = cv.itemcget(self._south_light['YELLOW'], 'fill')
			GreenLight = cv.itemcget(self._south_light['GREEN'], 'fill')
		elif direction == 'south':
			RedLight = cv.itemcget(self._north_light['RED'], 'fill')
			YellowLight = cv.itemcget(self._north_light['YELLOW'], 'fill')
			GreenLight = cv.itemcget(self._north_light['GREEN'], 'fill')
		elif direction == 'east':
			RedLight = cv.itemcget(self._west_light['RED'], 'fill')
			YellowLight = cv.itemcget(self._west_light['YELLOW'], 'fill')
			GreenLight = cv.itemcget(self._west_light['GREEN'], 'fill')
		elif direction == 'west':
			RedLight = cv.itemcget(self._east_light['RED'], 'fill')
			YellowLight = cv.itemcget(self._east_light['YELLOW'], 'fill')
			GreenLight = cv.itemcget(self._east_light['GREEN'], 'fill')

		if RedLight == 'red':
			return 'red'
		elif YellowLight == 'yellow':
			return 'yellow'
		else:
			return 'green'

	# registerVehicle --
	#
	#   A vehicle is waiting for this light to turn green.
	#   Add it to the list. When the light turns green,
	#   the vehicle will be told about it.
	#
	# Arguments:
	#   vehicle    A vehicle object name.
	#   direction  The direction the vehicle is moving.

	def registerVehicle(self, vehicle, direction):
		if      direction == 'north':
			self._northVehicleList.append(vehicle)
		elif direction == 'south':
			self._southVehicleList.append(vehicle)
		elif direction == 'east':
			self._eastVehicleList.append(vehicle)
		elif direction == 'west':
			self._westVehicleList.append(vehicle)

	# getQueueSize --
	#
	#   Return the number of vehicles waiting on a red in
	#   a particular direction.
	#
	# Arguments:
	#   direction   The direction the vehicle is moving.
	#
	# Results:
	#   The size of the red light queue for that direction.

	def getQueueSize(self, direction):
		if      direction == 'north':
			return len(self._northVehicleList)
		elif direction == 'south':
			return len(self._southVehicleList)
		elif direction == 'east':
			return len(self._eastVehicleList)
		elif direction == 'west':
			return len(self._westVehicleList)

	# setLightTimer --
	#
	#   Set a particular light's timer. The value is given in
	#   seconds, so convert to milliseconds.
	#
	# Arguments:
	#   light    NSGreenTimer, EWGreenTimer or YellowTimer.
	#   time     Light time in seconds.

	def setLightTimer(self, light, time):
		self._timeouts[light] = time * 1000

	# start --
	#
	#   Start the demo running.
	#
	# Arguments:
	#   None.

	def Start(self):
		self._fsm.enterStartState()
		self._fsm.Start()

	# pause --
	#
	#   Pause this demo.
	#
	# Arguments:
	#   None.

	def Pause(self):
		self._fsm.Pause()

	# continue --
	#
	#   Continue this demo.
	#
	# Arguments:
	#   None.

	def Continue(self):
		self._fsm.Continue()

	# stop --
	#
	#   Stop this demo.
	#
	# Arguments:
	#   None.

	def Stop(self):
		self._fsm.Stop()

	# State Machine Actions.
	#
	# The following methods are called by the state machine..

	def TurnLight(self, direction, color):
		cv = self._canvas
		if      direction == 'EWLIGHT':
			if      color == 'red':
				cv.itemconfigure(self._east_light['YELLOW'], fill='white')
				cv.itemconfigure(self._west_light['YELLOW'], fill='white')
				cv.itemconfigure(self._east_light['RED'], fill='red')
				cv.itemconfigure(self._west_light['RED'], fill='red')
			elif color == 'green':
				cv.itemconfigure(self._east_light['RED'], fill='white')
				cv.itemconfigure(self._west_light['RED'], fill='white')
				cv.itemconfigure(self._east_light['GREEN'], fill='green')
				cv.itemconfigure(self._west_light['GREEN'], fill='green')
			elif color  == 'yellow':
				cv.itemconfigure(self._east_light['GREEN'], fill='white')
				cv.itemconfigure(self._west_light['GREEN'], fill='white')
				cv.itemconfigure(self._east_light['YELLOW'], fill='yellow')
				cv.itemconfigure(self._west_light['YELLOW'], fill='yellow')
		elif direction == 'NSLIGHT':
			if      color == 'red':
				cv.itemconfigure(self._north_light['YELLOW'], fill='white')
				cv.itemconfigure(self._south_light['YELLOW'], fill='white')
				cv.itemconfigure(self._north_light['RED'], fill='red')
				cv.itemconfigure(self._south_light['RED'], fill='red')
			elif color == 'green':
				cv.itemconfigure(self._north_light['RED'], fill='white')
				cv.itemconfigure(self._south_light['RED'], fill='white')
				cv.itemconfigure(self._north_light['GREEN'], fill='green')
				cv.itemconfigure(self._south_light['GREEN'], fill='green')
			elif color == 'yellow':
				cv.itemconfigure(self._north_light['GREEN'], fill='white')
				cv.itemconfigure(self._south_light['GREEN'], fill='white')
				cv.itemconfigure(self._north_light['YELLOW'], fill='yellow')
				cv.itemconfigure(self._south_light['YELLOW'], fill='yellow')

	def SetTimer(self, timer):
		self._timerID = self._canvas.after(self._timeouts[timer], self.Timeout)

	def StopTimer(self):
		if self._timerID >= 0:
			self._canvas.after_cancel(self._timerID)
			self._timerID = -1

	def Timeout(self):
		self._timerID = -1
		self._fsm.Timeout()

	def ResetLights(self):
		cv = self._canvas

		cv.itemconfigure(self._east_light['YELLOW'], fill='white')
		cv.itemconfigure(self._west_light['YELLOW'], fill='white')
		cv.itemconfigure(self._east_light['RED'], fill='white')
		cv.itemconfigure(self._west_light['RED'], fill='white')
		cv.itemconfigure(self._east_light['GREEN'], fill='white')
		cv.itemconfigure(self._west_light['GREEN'], fill='white')

		cv.itemconfigure(self._north_light['YELLOW'], fill='white')
		cv.itemconfigure(self._south_light['YELLOW'], fill='white')
		cv.itemconfigure(self._north_light['RED'], fill='white')
		cv.itemconfigure(self._south_light['RED'], fill='white')
		cv.itemconfigure(self._north_light['GREEN'], fill='white')
		cv.itemconfigure(self._south_light['GREEN'], fill='white')

	# InformVehicles --
	#
	#   Tell the vehicles that were waiting on the green light
	#   that they can go now.
	#
	# Arguments:
	#   direction   Which light turned green.

	def InformVehicles(self, direction):
		if      direction == 'north':
			for vehicle in self._northVehicleList:
				vehicle.lightGreen()
			self._northVehicleList = []
		elif direction == 'south':
			for vehicle in self._southVehicleList:
				vehicle.lightGreen()
			self._southVehicleList = []
		elif direction == 'east':
			for vehicle in self._eastVehicleList:
				vehicle.lightGreen()
			self._eastVehicleList = []
		elif direction == 'west':
			for vehicle in self._westVehicleList:
				vehicle.lightGreen()
			self._westVehicleList = []

	def DrawRoads(self):
		cv = self._canvas
		# The roads are drawn as follows:
		#
		#        (x2,y1)   (x4,y1)
		#             |  |  |
		#             |     |
		#             |  |  |
		# (x1,y2)     |     |       (x5,y2)
		# ------------+  |  +------------
		#         (x2,y2) (x4,y2)
		# - - - - - -        - - - - - -
		#         (x2,y4) (x4,y4)   (x5,y4)
		# ------------+     +------------
		# (x1,y4)     |  |  |
		#             |     |
		#             |  |  |
		#             |     |
		#        (x2,y5) |(x4,y5)

		# Calculate the line segment's length.
		XLength = (self.getRoadLengthX() / 2) - self._roadWidth / 2
		YLength = (self.getRoadLengthY() / 2) - self._roadWidth / 2

		# Calculate the major coordinates.
		X1 = 0
		Y1 = 0
		X2 = XLength
		Y2 = YLength
		X3 = int(cv.cget('width')) / 2
		Y3 = int(cv.cget('height')) / 2
		X4 = int(cv.cget('width')) - XLength
		Y4 = int(cv.cget('height')) - YLength
		X5 = int(cv.cget('width'))
		Y5 = int(cv.cget('height'))

		# Put green lawns around the road.
		cv.create_rectangle(X1, Y1, X2, Y2,
			outline="",
			fill='green',
		)
		cv.create_rectangle(X1, Y4, X2, Y5,
			outline="",
			fill='green',
		)
		cv.create_rectangle(X4, Y4, X5, Y5,
			outline="",
			fill='green',
		)
		cv.create_rectangle(X4, Y1, X5, Y2,
			outline="",
			fill='green',
		)

		# Draw four connected lines where each drawing uses three
		# coordinates.
		cv.create_line(X1, Y2, X2, Y2, X2, Y1)
		cv.create_line(X4, Y1, X4, Y2, X5, Y2)
		cv.create_line(X1, Y4, X2, Y4, X2, Y5)
		cv.create_line(X4, Y5, X4, Y4, X5, Y4)

		# Now draw the lane markings.
		cv.create_line(X1, Y3, X2, Y3)
		cv.create_line(X3, Y1, X3, Y2)
		cv.create_line(X4, Y3, X5, Y3)
		cv.create_line(X3, Y4, X3, Y5)

	def DrawLights(self):
		cv = self._canvas
		# The lights are drawns as follows:
		#
		#  y1          +---+
		#              | o |green
		#              | o |yellow
		#              | o |red
		#  y2  +-------+---+-------+
		#      | o o o |   | o o o |
		#  y3  +-------+---+-------+
		#              | o |red
		#              | o |yellow
		#              | o |green
		#  y4          +---+
		#
		#    x1       x2   x3     x4
		# Store each light as a separate element in a table.

		# Figure out the coordinates for the stoplights.
		X1 = int(cv.cget('width')) / 2 - self._lightWidth / 2 - self._lightHeight
		Y1 = int(cv.cget('height')) / 2 - self._lightWidth / 2 - self._lightHeight
		X2 = X1 + self._lightHeight
		Y2 = Y1 + self._lightHeight
		X3 = X2 + self._lightWidth
		Y3 = Y2 + self._lightWidth
		X4 = X3 + self._lightHeight
		Y4 = Y3 + self._lightHeight

		# Draw the four stop lights boxes.
		cv.create_rectangle(X2, Y1, X3, Y2,
				outline='black',
				fill='black',
				width=1,
		)
		cv.create_rectangle(X1, Y2, X2, Y3,
				outline='black',
				fill='black',
				width=1,
		)
		cv.create_rectangle(X2, Y3, X3, Y4,
				outline='black',
				fill='black',
				width=1,
		)
		cv.create_rectangle(X3, Y2, X4, Y3,
				outline='black',
				fill='black',
				width=1,
		)

		# Draw the lights within the stoplights. Save the
		# canvas items into an array because they will be
		# referenced later. Because there are two lights
		self._north_light['RED'] = cv.create_oval(
				X2 + self._lightSpace,
				Y1 + self._lightSpace,
				X3 - self._lightSpace,
				Y1 + self._lightSpace + self._lightDiameter,
				outline='black',
				fill='white'
		)
		self._north_light['YELLOW'] = cv.create_oval(
				X2 + self._lightSpace,
				Y1 + self._lightSpace * 2 + self._lightDiameter,
				X3 - self._lightSpace,
				Y1 + self._lightSpace * 2 + self._lightDiameter * 2,
				outline='black',
				fill='white'
		)
		self._north_light['GREEN'] = cv.create_oval(
				X2 + self._lightSpace,
				Y1 + self._lightSpace * 3 + self._lightDiameter * 2,
				X3 - self._lightSpace,
				Y1 + self._lightSpace * 3 + self._lightDiameter * 3,
				outline='black',
				fill='white'
		)

		self._west_light['RED'] = cv.create_oval(
				X1 + self._lightSpace,
				Y2 + self._lightSpace,
				X1 + self._lightSpace + self._lightDiameter,
				Y3 - self._lightSpace,
				outline='black',
				fill='white'
		)
		self._west_light['YELLOW'] = cv.create_oval(
				X1 + self._lightSpace * 2 + self._lightDiameter,
				Y2 + self._lightSpace,
				X1 + self._lightSpace * 2 + self._lightDiameter * 2,
				Y3 - self._lightSpace,
				outline='black',
				fill='white'
		)
		self._west_light['GREEN'] = cv.create_oval(
				X1 + self._lightSpace * 3 + self._lightDiameter * 2,
				Y2 + self._lightSpace,
				X1 + self._lightSpace * 3 + self._lightDiameter * 3,
				Y3 - self._lightSpace,
				outline='black',
				fill='white'
		)

		self._south_light['GREEN'] = cv.create_oval(
				X2 + self._lightSpace,
				Y3 + self._lightSpace,
				X3 - self._lightSpace,
				Y3 + self._lightSpace + self._lightDiameter,
				outline='black',
				fill='white'
		)
		self._south_light['YELLOW'] = cv.create_oval(
				X2 + self._lightSpace,
				Y3 + self._lightSpace * 2 + self._lightDiameter,
				X3 - self._lightSpace,
				Y3 + self._lightSpace * 2 + self._lightDiameter * 2,
				outline='black',
				fill='white'
		)
		self._south_light['RED'] = cv.create_oval(
				X2 + self._lightSpace,
				Y3 + self._lightSpace * 3 + self._lightDiameter * 2,
				X3 - self._lightSpace,
				Y3 + self._lightSpace * 3 + self._lightDiameter * 3,
				outline='black',
				fill='white'
		)

		self._east_light['GREEN'] = cv.create_oval(
				X3 + self._lightSpace,
				Y2 + self._lightSpace,
				X3 + self._lightSpace + self._lightDiameter,
				Y3 - self._lightSpace,
				outline='black',
				fill='white'
		)
		self._east_light['YELLOW'] = cv.create_oval(
				X3 + self._lightSpace * 2 + self._lightDiameter,
				Y2 + self._lightSpace,
				X3 + self._lightSpace * 2 + self._lightDiameter * 2,
				Y3 - self._lightSpace,
				outline='black',
				fill='white'
		)
		self._east_light['RED'] = cv.create_oval(
				X3 + self._lightSpace * 3 + self._lightDiameter * 2,
				Y2 + self._lightSpace,
				X3 + self._lightSpace * 3 + self._lightDiameter * 3,
				Y3 - self._lightSpace,
				outline='black',
				fill='white'
		)
