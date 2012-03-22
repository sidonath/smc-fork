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
# Name
#  telephone.py
#
# Description
#  A simulation of an old fashioned touch-tone telephone.
#
# RCS ID
# $Id: telephone.py,v 1.3 2009/04/19 14:39:48 cwrapp Exp $
#
# CHANGE LOG
# $Log: telephone.py,v $
# Revision 1.3  2009/04/19 14:39:48  cwrapp
# Added call to enterStartState before issuing first FSM transition.
#
# Revision 1.2  2005/06/08 11:09:13  cwrapp
# + Updated Python code generator to place "pass" in methods with empty
#   bodies.
# + Corrected FSM errors in Python example 7.
# + Removed unnecessary includes from C++ examples.
# + Corrected errors in top-level makefile's distribution build.
#
# Revision 1.1  2005/05/28 17:48:30  cwrapp
# Added Python examples 1 - 4 and 7.
#
#

import sys, time
from Tkinter import *

import Telephone_sm

class Telephone:

	LONG_DISTANCE = 1
	LOCAL = 2
	EMERGENCY = 3

	NYC_TEMP = 4
	TIME = 5
	DEPOSIT_MONEY = 6
	LINE_BUSY = 7
	INVALID_NUMBER = 8

	SEC_PER_MINUTE = 60

	def __init__(self, root):
		self._root = root
		self._areaCode = ""
		self._exchange = ""
		self._local = ""
		self._display = ""
		self._receiverButton = None
		self._timerMap = {
				'ClockTimer': -1,
				'OffHookTimer': -1,
				'LoopTimer': -1,
				'RingTimer': -1,
		}
		self._timerAudioID = -1

		self._loadUI()

		# Create the state machine to drive this object.
		self._fsm = Telephone_sm.Telephone_sm(self)

		# DEBUG
		#self._fsm.setDebugFlag(True)


	# Create the user interface but don't display it yet.
	def _loadUI(self):
		self._root.title("Telephone demo")

		frameDisplay = Frame(self._root)
		frameDisplay.pack(
				side=TOP,
				fill=BOTH,
		)
		# Create the read-only phone number display.
		self._numberDisplay = Label(frameDisplay,
				width=30,
				bg='white',
				relief=SUNKEN,
				padx=5,
				pady=5,
		)
		self._numberDisplay.pack(
				side=TOP,
				padx=5,
				pady=5,
		)

		frameHook = Frame(self._root)
		frameHook.pack(
				side=TOP,
				expand=1,
		)
		# Create the off-hook/on-hook button.
		def onReceiver():
			text = self._receiverButton.cget('text')
			if text == "Pick up receiver":
				self._fsm.OffHook()
			elif text == "Put down receiver":
				self._fsm.OnHook()
			else:
				sys.stderr.write("Unknown receiver (%s).\n" % text)

		self._receiverButton = Button(frameHook,
				text="Pick up receiver",
				state=NORMAL,
				command=onReceiver,
				padx=10,
				pady=5,
				bd=3,
		)
		self._receiverButton.pack(
				side=TOP,
				padx= 5,
				pady= 5,
		)

		frameDial = Frame(self._root)
		frameDial.pack(
				side=TOP,
				fill=BOTH,
				padx=5,
				pady=5,
		)
		# Create the dialing buttons.
		i = 0
		for digit in ("123456789*0#"):
			b = Button(frameDial,
					text=digit,
					height=2,
					width=3,
					command=lambda digit=digit: self._fsm.Digit(digit),
			)
			b.grid(
					row=i/3,
					column=i%3,
					padx=1,
					pady=1,
			)
			i += 1

		frameStatus = Frame(self._root)
		frameStatus.pack(
				side=TOP,
				fill=BOTH,
		)
		self._soundDisplay = Label(frameStatus,
				relief=GROOVE,
		)
		self._soundDisplay.pack(
				side=TOP,
				fill='x',
				expand=1,
				anchor='s',
		)

		# Cntl-C stops the demo as well.
		self._root.bind('<Control-c>', lambda x: sys.exit(0))

	def Start(self):
		self._fsm.enterStartState()

	#-----------------------------------------------------------
	# State Machine Actions.
	#

	# Return the current area code.
	def getAreaCode(self):
		return self._areaCode

	# Return the exchange.
	def getExchange(self):
		return self._exchange

	# Return the local number.
	def getLocal(self):
		return self._local

	def routeCall(self, callType, areaCode, exchange, local):
		if callType == self.EMERGENCY:
			route = self.EMERGENCY
		elif (callType == self.LONG_DISTANCE
			and areaCode == "1212"
			and exchange == "555"
			and local == "1234"):
			route = self.NYC_TEMP
		elif exchange == "555":
			if local == "1212":
				route = self.TIME
			else:
				route = self.LINE_BUSY
		elif callType == self.LOCAL:
			route = self.DEPOSIT_MONEY
		else:
			route = self.INVALID_NUMBER

		# Call routing needs to be done asynchronouzly in order to
		# avoid issuing a transition within a transition.
		self._root.after(50, lambda: self._callRoute(route))

	def startTimer(self, name, delay):
		if name == "ClockTimer":
			self._timerMap[name] = self._root.after(delay, lambda: self._fsm.ClockTimer())
		elif name == "OffHookTimer":
			self._timerMap[name] = self._root.after(delay, lambda: self._fsm.OffHookTimer())
		elif name == "LoopTimer":
			self._timerMap[name] = self._root.after(delay, lambda: self._fsm.LoopTimer())
		elif name == "RingTimer":
			self._timerMap[name] = self._root.after(delay, lambda: self._fsm.RingTimer())

	def resetTimer(self, name, delay):
		if self._timerMap[name] >= 0:
			self._root.after_cancel(self._timerMap[name])
			self._timerMap[name] = -1;
			self.startTimer(name, delay)

	def stopTimer(self, name):
		if self._timerMap[name] >= 0:
			self._root.after_cancel(self._timerMap[name])
			self._timerMap[name] = -1;

	def play(self, name, delay):
		def endPlay():
			self._soundDisplay.configure(text="")
			self._timerAudioID = -1

		if self._timerAudioID >= 0:
			self._root.after_cancel(self._timerAudioID)
			self._timerAudioID = -1
		self._soundDisplay.configure(text=name)
		self._timerAudioID = self._root.after(delay, endPlay)

	def playTT(self, name):
		self.play(name, 400)

	def loop(self, name):
		if self._timerAudioID >= 0:
			self._root.after_cancel(self._timerAudioID)
			self._timerAudioID = -1
		self._soundDisplay.configure(text=name + " ...")

	def stopLoop(self, name):
		self._soundDisplay.configure(text="")

	def stopPlayback(self):
		if self._timerAudioID >= 0:
			self._root.after_cancel(self._timerAudioID)
			self._timerAudioID = -1
		self._soundDisplay.configure(text="")

	def playEmergency(self):
		self.play("911", 5000)

	def playNYCTemp(self):
		self.play("NYC_temp", 2000)

	def playDepositMoney(self):
		self.play("50_cents_please", 2000)

	def playTime(self):
		self.play("the_time_is ???", 2000)

	def playInvalidNumber(self):
		self.play("you_dialed ### could_not_be_completed", 2000)

	def getType(self):
		return self._callType

	def setType(self, type):
		self._callType = type

	def saveAreaCode(self, n):
		self._areaCode += n
		self.addDisplay(n)

	def saveExchange(self, n):
		self._exchange += n
		self.addDisplay(n)

	def saveLocal(self, n):
		self._local += n
		self.addDisplay(n)

	def addDisplay(self, character):
		self._display += character
		self._numberDisplay.configure(text=self._display)

	def clearDisplay(self):
		#Clear the internal data store.
		self._display = ""
		self._areaCode = ""
		self._local = ""
		self._exchange = ""

		# Put up the current time and date on the display.
		self._numberDisplay.configure(text="")

	def startClockTimer(self):
		currentTime = int(time.time())
		timeRemaining = self.SEC_PER_MINUTE - (currentTime % self.SEC_PER_MINUTE)

		# Figure out how long until the top of the minute
		# and set the timer for that amount.
		self.startTimer("ClockTimer", timeRemaining * 1000)

	def updateClock(self):
		text = time.strftime("%H:%M  %b %d, %Y", time.localtime(time.time()))
		self._numberDisplay.configure(text=text)

	def setReceiver(self, text):
		self._receiverButton.configure(text=text)

	def _callRoute(self, route):
		if route == self.EMERGENCY:
			self._fsm.Emergency()
		elif route == self.NYC_TEMP:
			self._fsm.NYCTemp()
		elif route == self.TIME:
			self._fsm.Time()
		elif route == self.DEPOSIT_MONEY:
			self._fsm.DepositMoney()
		elif route == self.LINE_BUSY:
			self._fsm.LineBusy()
		elif route == self.INVALID_NUMBER:
			self._fsm.InvalidNumber()

# Display the "telephone" user interface and run until
# the user quits the window.
root = Tk()
tel = Telephone(root)
tel.Start()
root.mainloop()
