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
# Stoplight --
#
#  When a timer goes off, change the light's color as per the
#  state machine.
#
# RCS ID
# $Id: Stoplight.rb,v 1.1 2005/06/16 17:52:03 fperrad Exp $
#
# CHANGE LOG
# $Log: Stoplight.rb,v $
# Revision 1.1  2005/06/16 17:52:03  fperrad
# Added Ruby examples 1 - 4 and 7.
#
#

require 'Stoplight_sm'

class Stoplight

	def initialize(canvas)
		@_canvas = canvas
		# Create the stop light's state machine.
		@_fsm = Smc_ex4::Stoplight_sm::new(self)

		@_east_light = {}
		@_west_light = {}
		@_north_light = {}
		@_south_light = {}
		@_roadWidth = 38
		@_lightDiameter = 6
		@_lightSpace = 2

		# Set the light height and width.
		@_lightWidth = @_lightDiameter + @_lightSpace * 2
		@_lightHeight = @_lightDiameter * 3 + @_lightSpace * 4

		@_northVehicleList = []
		@_southVehicleList = []
		@_eastVehicleList = []
		@_westVehicleList = []

		# Create the stoplight GUI. Draw the roads.
		drawRoads

		# Draw the stoplights.
		drawLights

		# Set each light timer.
		@_timeouts = {
				'NSGreenTimer' => 7000,
				'EWGreenTimer' => 5000,
				'YellowTimer' => 2000
		}

		@_timerID = nil

		# Uncomment to see debug output.
		#@_fsm.setDebugFlag(true)
	end

	# getRoadLengthX --
	#
	#   Return the road's length in X direction.
	#
	# Arguments:
	#   None.
	#
	# Results:
	#   Pixel length of road in X direction.

	def getRoadLengthX()
		return @_canvas.cget('width').to_i
	end

	# getRoadLengthY --
	#
	#   Return the road's length in Y direction in pixels.
	#
	# Arguments:
	#   None.
	#
	# Results:
	#   Pixel length of road in Y direction.

	def getRoadLengthY()
		return @_canvas.cget('height').to_i
	end

	# getRoadWidth --
	#
	#   Return road's width in pixels.
	#
	# Arguments:
	#   None.
	#
	# Results:
	#   Road's width in pixels.

	def getRoadWidth()
		return @_roadWidth
	end

	# getLight --
	#
	#   Return a specified stop lights color.
	#
	# Arguments:
	#   direction   Must be either north, south east or west.
	#
	# Results:
	#   Returns the color for that direction.

	def getLight(direction)
		# The direction represents which way the vehicle
		# is facing. This is the opposite direction in which
		# the light is facing.
		if      direction == 'north' then
			redLight = @_canvas.itemcget(@_south_light['RED'], 'fill')
			yellowLight = @_canvas.itemcget(@_south_light['YELLOW'], 'fill')
			greenLight = @_canvas.itemcget(@_south_light['GREEN'], 'fill')
		elsif direction == 'south' then
			redLight = @_canvas.itemcget(@_north_light['RED'], 'fill')
			yellowLight = @_canvas.itemcget(@_north_light['YELLOW'], 'fill')
			greenLight = @_canvas.itemcget(@_north_light['GREEN'], 'fill')
		elsif direction == 'east' then
			redLight = @_canvas.itemcget(@_west_light['RED'], 'fill')
			yellowLight = @_canvas.itemcget(@_west_light['YELLOW'], 'fill')
			greenLight = @_canvas.itemcget(@_west_light['GREEN'], 'fill')
		elsif direction == 'west' then
			redLight = @_canvas.itemcget(@_east_light['RED'], 'fill')
			yellowLight = @_canvas.itemcget(@_east_light['YELLOW'], 'fill')
			greenLight = @_canvas.itemcget(@_east_light['GREEN'], 'fill')
		end

		if redLight == 'red' then
			return 'red'
		elsif yellowLight == 'yellow' then
			return 'yellow'
		else
			return 'green'
		end
	end

	# registerVehicle --
	#
	#   A vehicle is waiting for this light to turn green.
	#   Add it to the list. When the light turns green,
	#   the vehicle will be told about it.
	#
	# Arguments:
	#   vehicle    A vehicle object name.
	#   direction  The direction the vehicle is moving.

	def registerVehicle(vehicle, direction)
		if      direction == 'north' then
			@_northVehicleList.push(vehicle)
		elsif direction == 'south' then
			@_southVehicleList.push(vehicle)
		elsif direction == 'east' then
			@_eastVehicleList.push(vehicle)
		elsif direction == 'west' then
			@_westVehicleList.push(vehicle)
		end
	end

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

	def getQueueSize(direction)
		if      direction == 'north' then
			return @_northVehicleList.size
		elsif direction == 'south' then
			return @_southVehicleList.size
		elsif direction == 'east' then
			return @_eastVehicleList.size
		elsif direction == 'west' then
			return @_westVehicleList.size
		end
	end

	# setLightTimer --
	#
	#   Set a particular light's timer. The value is given in
	#   seconds, so convert to milliseconds.
	#
	# Arguments:
	#   light    NSGreenTimer, EWGreenTimer or YellowTimer.
	#   time     Light time in seconds.

	def setLightTimer(light, time)
		@_timeouts[light] = time * 1000
	end

	# start --
	#
	#   Start the demo running.
	#
	# Arguments:
	#   None.

	def Start()
		@_fsm.Start
	end

	# pause --
	#
	#   Pause this demo.
	#
	# Arguments:
	#   None.

	def Pause()
		@_fsm.Pause
	end

	# continue --
	#
	#   Continue this demo.
	#
	# Arguments:
	#   None.

	def Continue()
		@_fsm.Continue
	end

	# stop --
	#
	#   Stop this demo.
	#
	# Arguments:
	#   None.

	def Stop()
		@_fsm.Stop
	end

	# State Machine Actions.
	#
	# The following methods are called by the state machine..

	def TurnLight(direction, color)
		if      direction == 'EWLIGHT' then
			if      color == 'red' then
				@_canvas.itemconfigure(@_east_light['YELLOW'], 'fill' => 'white')
				@_canvas.itemconfigure(@_west_light['YELLOW'], 'fill' => 'white')
				@_canvas.itemconfigure(@_east_light['RED'], 'fill' => 'red')
				@_canvas.itemconfigure(@_west_light['RED'], 'fill' => 'red')
			elsif color == 'green' then
				@_canvas.itemconfigure(@_east_light['RED'], 'fill' => 'white')
				@_canvas.itemconfigure(@_west_light['RED'], 'fill' => 'white')
				@_canvas.itemconfigure(@_east_light['GREEN'], 'fill' => 'green')
				@_canvas.itemconfigure(@_west_light['GREEN'], 'fill' => 'green')
			elsif color  == 'yellow' then
				@_canvas.itemconfigure(@_east_light['GREEN'], 'fill' => 'white')
				@_canvas.itemconfigure(@_west_light['GREEN'], 'fill' => 'white')
				@_canvas.itemconfigure(@_east_light['YELLOW'], 'fill' => 'yellow')
				@_canvas.itemconfigure(@_west_light['YELLOW'], 'fill' => 'yellow')
			end
		elsif direction == 'NSLIGHT' then
			if      color == 'red' then
				@_canvas.itemconfigure(@_north_light['YELLOW'], 'fill' => 'white')
				@_canvas.itemconfigure(@_south_light['YELLOW'], 'fill' => 'white')
				@_canvas.itemconfigure(@_north_light['RED'], 'fill' => 'red')
				@_canvas.itemconfigure(@_south_light['RED'], 'fill' => 'red')
			elsif color == 'green' then
				@_canvas.itemconfigure(@_north_light['RED'], 'fill' => 'white')
				@_canvas.itemconfigure(@_south_light['RED'], 'fill' => 'white')
				@_canvas.itemconfigure(@_north_light['GREEN'], 'fill' => 'green')
				@_canvas.itemconfigure(@_south_light['GREEN'], 'fill' => 'green')
			elsif color == 'yellow' then
				@_canvas.itemconfigure(@_north_light['GREEN'], 'fill' => 'white')
				@_canvas.itemconfigure(@_south_light['GREEN'], 'fill' => 'white')
				@_canvas.itemconfigure(@_north_light['YELLOW'], 'fill' => 'yellow')
				@_canvas.itemconfigure(@_south_light['YELLOW'], 'fill' => 'yellow')
			end
		end
	end

	def SetTimer(timer)
		@_timerID = TkAfter.new(@_timeouts[timer], 1, proc { timeout } )
		@_timerID.start
	end

	def StopTimer()
		unless @_timerID.nil? then
			@_timerID.cancel
			@_timerID = nil
		end
	end

	def timeout()
		@_timerID = nil
		@_fsm.Timeout
	end

	def ResetLights()
		@_canvas.itemconfigure(@_east_light['YELLOW'], 'fill' => 'white')
		@_canvas.itemconfigure(@_west_light['YELLOW'], 'fill' => 'white')
		@_canvas.itemconfigure(@_east_light['RED'], 'fill' => 'white')
		@_canvas.itemconfigure(@_west_light['RED'], 'fill' => 'white')
		@_canvas.itemconfigure(@_east_light['GREEN'], 'fill' => 'white')
		@_canvas.itemconfigure(@_west_light['GREEN'], 'fill' => 'white')

		@_canvas.itemconfigure(@_north_light['YELLOW'], 'fill' => 'white')
		@_canvas.itemconfigure(@_south_light['YELLOW'], 'fill' => 'white')
		@_canvas.itemconfigure(@_north_light['RED'], 'fill' => 'white')
		@_canvas.itemconfigure(@_south_light['RED'], 'fill' => 'white')
		@_canvas.itemconfigure(@_north_light['GREEN'], 'fill' => 'white')
		@_canvas.itemconfigure(@_south_light['GREEN'], 'fill' => 'white')
	end

	# InformVehicles --
	#
	#   Tell the vehicles that were waiting on the green light
	#   that they can go now.
	#
	# Arguments:
	#   direction   Which light turned green.

	def InformVehicles(direction)
		if      direction == 'north' then
			for vehicle in @_northVehicleList do
				vehicle.lightGreen
			end
			@_northVehicleList = []
		elsif direction == 'south' then
			for vehicle in @_southVehicleList do
				vehicle.lightGreen
			end
			@_southVehicleList = []
		elsif direction == 'east' then
			for vehicle in @_eastVehicleList do
				vehicle.lightGreen
			end
			@_eastVehicleList = []
		elsif direction == 'west' then
			for vehicle in @_westVehicleList do
				vehicle.lightGreen
			end
			@_westVehicleList = []
		end
	end

	def drawRoads()
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
		xLength = getRoadLengthX / 2 - @_roadWidth / 2
		yLength = getRoadLengthY / 2 - @_roadWidth / 2

		# Calculate the major coordinates.
		x1 = 0
		y1 = 0
		x2 = xLength
		y2 = yLength
		x3 = @_canvas.cget('width').to_i / 2
		y3 = @_canvas.cget('height').to_i / 2
		x4 = @_canvas.cget('width').to_i - xLength
		y4 = @_canvas.cget('height').to_i - yLength
		x5 = @_canvas.cget('width').to_i
		y5 = @_canvas.cget('height').to_i

		# Put green lawns around the road.
		TkcRectangle.new(@_canvas, x1, y1, x2, y2,
			'outline' => "",
			'fill' => 'green'
		)
		TkcRectangle.new(@_canvas, x1, y4, x2, y5,
			'outline' => "",
			'fill' => 'green'
		)
		TkcRectangle.new(@_canvas, x4, y4, x5, y5,
			'outline' => "",
			'fill' => 'green'
		)
		TkcRectangle.new(@_canvas, x4, y1, x5, y2,
			'outline' => "",
			'fill' => 'green'
		)

		# Draw four connected lines where each drawing uses three
		# coordinates.
		TkcLine.new(@_canvas, x1, y2, x2, y2, x2, y1)
		TkcLine.new(@_canvas, x4, y1, x4, y2, x5, y2)
		TkcLine.new(@_canvas, x1, y4, x2, y4, x2, y5)
		TkcLine.new(@_canvas, x4, y5, x4, y4, x5, y4)

		# Now draw the lane markings.
		TkcLine.new(@_canvas, x1, y3, x2, y3)
		TkcLine.new(@_canvas, x3, y1, x3, y2)
		TkcLine.new(@_canvas, x4, y3, x5, y3)
		TkcLine.new(@_canvas, x3, y4, x3, y5)
	end

	def drawLights()
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
		x1 = @_canvas.cget('width').to_i / 2 - @_lightWidth / 2 - @_lightHeight
		y1 = @_canvas.cget('height').to_i / 2 - @_lightWidth / 2 - @_lightHeight
		x2 = x1 + @_lightHeight
		y2 = y1 + @_lightHeight
		x3 = x2 + @_lightWidth
		y3 = y2 + @_lightWidth
		x4 = x3 + @_lightHeight
		y4 = y3 + @_lightHeight

		# Draw the four stop lights boxes.
		TkcRectangle.new(@_canvas, x2, y1, x3, y2,
				'outline' => 'black',
				'fill' => 'black',
				'width' => 1
		)
		TkcRectangle.new(@_canvas, x1, y2, x2, y3,
				'outline' => 'black',
				'fill' => 'black',
				'width' => 1
		)
		TkcRectangle.new(@_canvas, x2, y3, x3, y4,
				'outline' => 'black',
				'fill' => 'black',
				'width' => 1
		)
		TkcRectangle.new(@_canvas, x3, y2, x4, y3,
				'outline' => 'black',
				'fill' => 'black',
				'width' => 1
		)

		# Draw the lights within the stoplights. Save the
		# canvas items into an array because they will be
		# referenced later. Because there are two lights
		@_north_light['RED'] = TkcOval.new(@_canvas,
				x2 + @_lightSpace,
				y1 + @_lightSpace,
				x3 - @_lightSpace,
				y1 + @_lightSpace + @_lightDiameter,
				'outline' => 'black',
				'fill' => 'white'
		)
		@_north_light['YELLOW'] = TkcOval.new(@_canvas,
				x2 + @_lightSpace,
				y1 + @_lightSpace * 2 + @_lightDiameter,
				x3 - @_lightSpace,
				y1 + @_lightSpace * 2 + @_lightDiameter * 2,
				'outline' => 'black',
				'fill' => 'white'
		)
		@_north_light['GREEN'] = TkcOval.new(@_canvas,
				x2 + @_lightSpace,
				y1 + @_lightSpace * 3 + @_lightDiameter * 2,
				x3 - @_lightSpace,
				y1 + @_lightSpace * 3 + @_lightDiameter * 3,
				'outline' => 'black',
				'fill' => 'white'
		)

		@_west_light['RED'] = TkcOval.new(@_canvas,
				x1 + @_lightSpace,
				y2 + @_lightSpace,
				x1 + @_lightSpace + @_lightDiameter,
				y3 - @_lightSpace,
				'outline' => 'black',
				'fill' => 'white'
		)
		@_west_light['YELLOW'] = TkcOval.new(@_canvas,
				x1 + @_lightSpace * 2 + @_lightDiameter,
				y2 + @_lightSpace,
				x1 + @_lightSpace * 2 + @_lightDiameter * 2,
				y3 - @_lightSpace,
				'outline' => 'black',
				'fill' => 'white'
		)
		@_west_light['GREEN'] = TkcOval.new(@_canvas,
				x1 + @_lightSpace * 3 + @_lightDiameter * 2,
				y2 + @_lightSpace,
				x1 + @_lightSpace * 3 + @_lightDiameter * 3,
				y3 - @_lightSpace,
				'outline' => 'black',
				'fill' => 'white'
		)

		@_south_light['GREEN'] = TkcOval.new(@_canvas,
				x2 + @_lightSpace,
				y3 + @_lightSpace,
				x3 - @_lightSpace,
				y3 + @_lightSpace + @_lightDiameter,
				'outline' => 'black',
				'fill' => 'white'
		)
		@_south_light['YELLOW'] = TkcOval.new(@_canvas,
				x2 + @_lightSpace,
				y3 + @_lightSpace * 2 + @_lightDiameter,
				x3 - @_lightSpace,
				y3 + @_lightSpace * 2 + @_lightDiameter * 2,
				'outline' => 'black',
				'fill' => 'white'
		)
		@_south_light['RED'] = TkcOval.new(@_canvas,
				x2 + @_lightSpace,
				y3 + @_lightSpace * 3 + @_lightDiameter * 2,
				x3 - @_lightSpace,
				y3 + @_lightSpace * 3 + @_lightDiameter * 3,
				'outline' => 'black',
				'fill' => 'white'
		)

		@_east_light['GREEN'] = TkcOval.new(@_canvas,
				x3 + @_lightSpace,
				y2 + @_lightSpace,
				x3 + @_lightSpace + @_lightDiameter,
				y3 - @_lightSpace,
				'outline' => 'black',
				'fill' => 'white'
		)
		@_east_light['YELLOW'] = TkcOval.new(@_canvas,
				x3 + @_lightSpace * 2 + @_lightDiameter,
				y2 + @_lightSpace,
				x3 + @_lightSpace * 2 + @_lightDiameter * 2,
				y3 - @_lightSpace,
				'outline' => 'black',
				'fill' => 'white'
		)
		@_east_light['RED'] = TkcOval.new(@_canvas,
				x3 + @_lightSpace * 3 + @_lightDiameter * 2,
				y2 + @_lightSpace,
				x3 + @_lightSpace * 3 + @_lightDiameter * 3,
				y3 - @_lightSpace,
				'outline' => 'black',
				'fill' => 'white'
		)
	end

end
