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
# Name
#  telephone.rb
#
# Description
#  A simulation of an old fashioned touch-tone telephone.
#
# RCS ID
# $Id: telephone.rb,v 1.2 2009/04/11 14:29:14 cwrapp Exp $
#
# CHANGE LOG
# $Log: telephone.rb,v $
# Revision 1.2  2009/04/11 14:29:14  cwrapp
# Added called to enterStartState.
#
# Revision 1.1  2005/06/16 17:52:04  fperrad
# Added Ruby examples 1 - 4 and 7.
#
#

require 'time'
require 'tk'

require 'Telephone_sm'

class Telephone

	LONG_DISTANCE = 1
	LOCAL = 2
	EMERGENCY = 3

	NYC_TEMP = 4
	TIME = 5
	DEPOSIT_MONEY = 6
	LINE_BUSY = 7
	INVALID_NUMBER = 8

	SEC_PER_MINUTE = 60

	def initialize(root)
		@_root = root
		@_areaCode = ""
		@_exchange = ""
		@_local = ""
		@_display = ""
		@_receiverButton = nil
		@_timerMap = {
				'ClockTimer'=> nil,
				'OffHookTimer'=> nil,
				'LoopTimer'=> nil,
				'RingTimer'=> nil,
		}
		@_timerAudioID = nil

		_loadUI

		# Create the state machine to drive this object.
		@_fsm = Telephone_sm::new(self)

		# DEBUG
		#@_fsm.setDebugFlag(true)
	end


	# Create the user interface but don't display it yet.
	def _loadUI()
		@_root.title("Telephone demo")

		frameDisplay = TkFrame.new(@_root)
		frameDisplay.pack(
				'side' => 'top',
				'fill' => 'both'
		)
		# Create the read-only phone number display.
		@_numberDisplay = TkLabel.new(frameDisplay,
			'width' => 30,
			'bg' => 'white',
			'relief' => 'sunken',
			'padx' => 5,
			'pady' => 5
		)
		@_numberDisplay.pack(
			'side' => 'top',
			'padx' => 5,
			'pady' => 5
		)

		frameHook = TkFrame.new(@_root)
		frameHook.pack(
			'side' => 'top',
			'expand' => 1
		)
		# Create the off-hook/on-hook button.
		@_receiverButton = TkButton.new(frameHook,
			'text' =>  "Pick up receiver",
			'state' => 'normal',
			'command' => proc {
				text = @_receiverButton.cget('text')
				if text == "Pick up receiver" then
					@_fsm.OffHook
				elsif text == "Put down receiver" then
					@_fsm.OnHook
				else
					$stderr.printf("Unknown receiver (%s).\n", text)
				end
			},
			'padx' => 10,
			'pady' => 5,
			'bd'	=>  3
		)
		@_receiverButton.pack(
				'side' => 'top',
				'padx' => 5,
				'pady' => 5
		)

		frameDial = TkFrame.new(@_root)
		frameDial.pack(
			'side' => 'top',
			'fill' => 'both',
			'padx' => 5,
			'pady' => 5
		)
		# Create the dialing buttons.
		i = 0
		"123456789*0#".split(//).each do |digit|
			b = TkButton.new(frameDial,
				'text' => digit,
				'height' => 2,
				'width' => 3,
				'command' => proc { @_fsm.Digit(digit) }
			)
			b.grid(
				'row' => i/3,
				'column' => i%3,
				'padx' => 1,
				'pady' => 1
			)
			i += 1
		end

		frameStatus = TkFrame.new(@_root)
		frameStatus.pack(
			'side' => 'top',
			'fill' => 'both'
		)
		@_soundDisplay = TkLabel.new(frameStatus,
			'relief' => 'groove'
		)
		@_soundDisplay.pack(
			'side' => 'top',
			'fill' => 'x',
			'expand' => 1,
			'anchor' => 's'
		)

		# Cntl-C stops the demo as well.
		@_root.bind('Control-c') { exit }
	end

    def startFSM()
        @_fsm.enterStartState
    end

	#-----------------------------------------------------------
	# State Machine Actions.
	#

	# Return the current area code.
	def getAreaCode()
		return @_areaCode
	end

	# Return the exchange.
	def getExchange()
		return @_exchange
	end

	# Return the local number.
	def getLocal()
		return @_local
	end

	def routeCall(callType, areaCode, exchange, local)
		if callType == EMERGENCY then
			route = EMERGENCY
		elsif (callType == LONG_DISTANCE and
			areaCode == "1212" and
			exchange == "555" and
			local == "1234") then
			route = NYC_TEMP
		elsif exchange == "555" then
			if local == "1212" then
				route = TIME
			else
				route = LINE_BUSY
			end
		elsif callType == LOCAL then
			route = DEPOSIT_MONEY
		else
			route = INVALID_NUMBER
		end

		# Call routing needs to be done asynchronouzly in order to
		# avoid issuing a transition within a transition.
		Tk.after(50, proc { _callRoute(route) } )
	end

	def startTimer(name, delay)
		if name == "ClockTimer" then
			@_timerMap[name] = TkAfter.new(delay, 1, proc { @_fsm.ClockTimer } )
		elsif name == "OffHookTimer" then
   			@_timerMap[name] = TkAfter.new(delay, 1, proc { @_fsm.OffHookTimer } )
		elsif name == "LoopTimer" then
			@_timerMap[name] = TkAfter.new(delay, 1, proc { @_fsm.LoopTimer } )
		elsif name == "RingTimer" then
			@_timerMap[name] = TkAfter.new(delay, 1, proc { @_fsm.RingTimer } )
		end
		@_timerMap[name].start
	end

	def resetTimer(name)
		unless @_timerMap[name].nil? then
			@_timerMap[name].restart
		end
	end

	def stopTimer(name)
		unless @_timerMap[name].nil? then
			@_timerMap[name].cancel
			@_timerMap[name] = nil
		end
	end

	def play(name, delay)
		unless @_timerAudioID.nil? then
			@_timerAudioID.cancel
			@_timerAudioID = nil
		end
		@_soundDisplay.configure('text' => name)
		@_timerAudioID = TkAfter.new(delay, 1, proc {
			@_soundDisplay.configure('text' => "")
			@_timerAudioID = nil
		} )
		@_timerAudioID.start
	end

	def playTT(name)
		play(name, 400)
	end

	def loop(name)
		unless @_timerAudioID.nil? then
			@_timerAudioID.cancel
			@_timerAudioID = nil
		end
		@_soundDisplay.configure('text' => name + " ...")
	end

	def stopLoop(name)
		@_soundDisplay.configure('text' => "")
	end

	def stopPlayback()
		unless @_timerAudioID.nil? then
			@_timerAudioID.cancel
			@_timerAudioID = nil
		end
		@_soundDisplay.configure('text' => "")
	end

	def playEmergency()
		play("911", 5000)
	end

	def playNYCTemp()
		play("NYC_temp", 2000)
	end

	def playDepositMoney()
		play("50_cents_please", 2000)
	end

	def playTime()
		play("the_time_is ???", 2000)
	end

	def playInvalidNumber()
		play("you_dialed ### could_not_be_completed", 2000)
	end

	def getType()
		return @_callType
	end

	def setType(type)
		@_callType = type
	end

	def saveAreaCode(n)
		@_areaCode += n
		addDisplay(n)
	end

	def saveExchange(n)
		@_exchange += n
		addDisplay(n)
	end

	def saveLocal(n)
		@_local += n
		addDisplay(n)
	end

	def addDisplay(character)
		@_display += character
		@_numberDisplay.configure('text' => @_display)
	end

	def clearDisplay()
		#Clear the internal data store.
		@_display = ""
		@_areaCode = ""
		@_local = ""
		@_exchange = ""

		# Put up the current time and date on the display.
		@_numberDisplay.configure('text' => "")
	end

	def startClockTimer()
		currentTime = Time::now.to_i
		timeRemaining = SEC_PER_MINUTE - (currentTime % SEC_PER_MINUTE)

		# Figure out how long until the top of the minute
		# and set the timer for that amount.
		startTimer("ClockTimer", timeRemaining * 1000)
	end

	def updateClock()
		text = Time::now.localtime.strftime("%H:%M  %b %d, %Y")
		@_numberDisplay.configure('text' => text)
	end

	def setReceiver(text)
		@_receiverButton.configure('text' => text)
	end

	def _callRoute(route)
		if route == EMERGENCY then
			@_fsm.Emergency
		elsif route == NYC_TEMP then
			@_fsm.NYCTemp
		elsif route == TIME then
			@_fsm.Time
		elsif route == DEPOSIT_MONEY then
			@_fsm.DepositMoney
		elsif route == LINE_BUSY then
			@_fsm.LineBusy
		elsif route == INVALID_NUMBER then
			@_fsm.InvalidNumber
		end
	end

end

# Display the "telephone" user interface and run until
# the user quits the window.
root = TkRoot.new
tel = Telephone.new(root)
tel.startFSM
Tk.mainloop
