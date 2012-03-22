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
# Vehicle --
#
#  Draws a generic vehicle on the map (a black square) which
#  moves in straight lines along the road and obeys the stop light.
#
# RCS ID
# $Id: Vehicle.rb,v 1.1 2005/06/16 17:52:03 fperrad Exp $
#
# CHANGE LOG
# $Log: Vehicle.rb,v $
# Revision 1.1  2005/06/16 17:52:03  fperrad
# Added Ruby examples 1 - 4 and 7.
#
#

require 'tk'

require 'Vehicle_sm'

class Vehicle

	@@_speed = 2

	def initialize(stoplight, direction, canvas)
		@_fsm = Smc_ex4::Vehicle_sm::new(self)

		# The canvas to draw on and the direction this vehicle is
		# moving.
		@_canvas = canvas
		@_direction = direction

		# The stoplight object is responsible knowing the road
		# layout. Ask it for all relevant information.
		@_stoplight = stoplight

		# This vehicle is initially at the road's outside edge.
		# Figure out the road's length.
		xLength = stoplight.getRoadLengthX
		yLength = stoplight.getRoadLengthY
		laneWidth = stoplight.getRoadWidth / 2

		# The vehicle is 12 pixels x 12 pixels.
		@_vehicleSize = 6

		# A 3 pixel separation is to be maintained between vehicles.
		@_vehicleSeparation = 3

		# How far away the vehicle is from the curb.
		curbOffset = (laneWidth - @_vehicleSize) / 2

		# The vehicle's current canvas location. This is the
		# square's upper left hand corner.
		if      direction == 'north' then
			@_xpos = (xLength / 2) + curbOffset
			@_ypos = yLength - @_vehicleSize
		elsif direction == 'south' then
			@_xpos = (xLength / 2) - laneWidth + curbOffset
			@_ypos = 0
		elsif direction == 'east' then
			@_xpos = 0
			@_ypos = (yLength / 2) + curbOffset
		elsif direction == 'west' then
			@_xpos = xLength - @_vehicleSize
			@_ypos = (yLength / 2) - laneWidth + curbOffset
		end
		# Put the vehicle on display.
		@_canvasID = TkcRectangle.new(canvas,
				@_xpos,
				@_ypos,
				@_xpos + @_vehicleSize,
				@_ypos + @_vehicleSize,
				'fill' => 'black',
				'outline' => 'white'
		)

		# Move this vehicle along at near movie-refresh rate.
		@_redrawRate = 1000 / 60

		# Store the after's timer ID here.
		@_timerID = nil

		# Set this flag to true when the vehicle has
		# completed its trip.
		@_isDoneFlag = false

		# Uncomment to see debug output.
		#@_fsm.setDebugFlag(true)
	end

	def _delete()
		unless @_timerID.nil? then
			@_timerID.cancel
			@_timerID = nil
		end
		@_canvas.delete(@_canvasID)
	end

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

	def timeout()
		@_timerID = nil
		if offCanvas then
			@_fsm.TripDone
		elsif atIntersection and getLight != 'green' then
			@_fsm.LightRed
		else
			@_fsm.KeepGoing
		end
	end

	def getLight()
		return @_stoplight.getLight(@_direction)
	end

	# lightGreen --
	#
	#   The light has turned green. Time to get moving again.
	#
	# Arguments:
	#   None

	def lightGreen()
		@_fsm.LightGreen
	end

	# setSpeed --
	#
	#   Set speed for all vehicles.
	#
	# Arguments:
	#   speed   In pixels.

	def Vehicle.setSpeed(speed)
		if speed < 1 or speed > 10 then
			printf "Invalid speed (%d).\n", speed
		else
			@@_speed = speed
		end
	end

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

	def isDone()
		return @_isDoneFlag
	end

	# start --
	#
	#   Start this vehicle running.
	#
	# Arguments:
	#   None.

	def Start()
		@_fsm.Start
	end

	# pause --
	#
	#   Pause this vehicles' running.
	#
	# Arguments:
	#   None.

	def Pause()
		@_fsm.Pause
	end

	# continue --
	#
	#   Continue this vehicles' running.
	#
	# Arguments:
	#   None.

	def Continue()
		@_fsm.Continue
	end

	# stop --
	#
	#   Stop this vehicles' running.
	#
	# Arguments:
	#   None.
	#

	def Stop()
		@_fsm.Stop
		_delete
	end

	# State Machine Actions
	#
	# The following methods are called by the state machine.

	# SetTimer --
	#
	#   Set the timer for the next move.
	#
	# Arguments:
	#   None.

	def SetTimer()
		@_timerID = TkAfter.new(@_redrawRate, 1, proc { timeout } )
		@_timerID.start
	end

	# StopTimer --
	#
	#   Stop the vehicle's timer.
	#
	# Arguments:
	#   None.

	def StopTimer()
		unless @_timerID.nil? then
			@_timerID.cancel
			@_timerID = nil
		end
	end

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

	def Move()
		if      @_direction == 'north' then
			xMove = 0
			yMove = - @@_speed
		elsif @_direction == 'south' then
			xMove = 0
			yMove = @@_speed
		elsif @_direction == 'east' then
			xMove = @@_speed
			yMove = 0
		elsif @_direction == 'west' then
			xMove = - @@_speed
			yMove = 0
		end

		@_canvas.move(@_canvasID, xMove, yMove)

		@_xpos += xMove
		@_ypos += yMove
	end

	# RegisterWithLight --
	#
	#   When the light turns green, it will inform us.
	#
	# Arguments:
	#   None.

	def RegisterWithLight()
		@_stoplight.registerVehicle(self, @_direction)
	end

	# SelfDestruct --
	#
	#   Remove the vehicle from the canvas.
	#
	# Arguments:
	#   None.

	def SelfDestruct()
		@_canvas.delete(@_canvasID)
		@_canvasID = -1
		@_isDoneFlag = true
	end

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

	def offCanvas()
		if      @_direction == 'north' then
			return (@_ypos - @@_speed) <= 0
		elsif @_direction == 'south' then
			yLength = @_stoplight.getRoadLengthY
			return (@_ypos + @@_speed) >= yLength
		elsif @_direction == 'east' then
			xLength = @_stoplight.getRoadLengthX
			return (@_xpos + @@_speed) >= xLength
		elsif @_direction == 'west' then
			return (@_xpos - @@_speed) <= 0
		end
	end

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

	def atIntersection()
		# The vehicle is not at the intersection until proven
		# otherwise.
		retval = false

		xLength = @_stoplight.getRoadLengthX
		yLength = @_stoplight.getRoadLengthY
		laneWidth = @_stoplight.getRoadWidth / 2

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
		numVehicles = @_stoplight.getQueueSize(@_direction)
		lenVehicles = (@_vehicleSize + @_vehicleSeparation) * numVehicles
		if      @_direction == 'north' then
			yIntersection = (yLength / 2) + laneWidth + (@_vehicleSize / 2) + lenVehicles
			retval = (@_ypos > yIntersection) && (@_ypos - @@_speed <= yIntersection)
		elsif @_direction == 'south' then
			yIntersection = (yLength / 2) - laneWidth - (@_vehicleSize / 2) - lenVehicles
			retval = (@_ypos < yIntersection) && (@_ypos + @@_speed >= yIntersection)
		elsif @_direction == 'east' then
			xIntersection = (xLength / 2) - laneWidth - (@_vehicleSize / 2) - lenVehicles
			retval = (@_xpos < xIntersection) && (@_xpos + @@_speed >= xIntersection)
		elsif @_direction == 'west' then
			xIntersection = (xLength / 2) + laneWidth + (@_vehicleSize / 2) + lenVehicles
			retval = (@_xpos > xIntersection) && (@_xpos - @@_speed <= xIntersection)
		end
		return retval
	end

end
