/*
This file is for qunexus Port 3, portIndex 2.
On this port, one can send and measure control voltage,
such as from modular synthesizers.

*** TO DO ***
* test voltage IO with CV cables connect to a modular synth
* write code example that creates a mono voicer for pitch CV / gate outs

	// cvOut assumes a mono hardware synth with noteOn:
	// 1. noteOn opens gate CV to 5V
	// 2. midi noteNum of noteOn is converted to pitch CV
	// legato - is probably implemented in QuNexus already,
	// when QuN keys are used as CV control; should be:
	// if gate is already open, keep it open;
	// noteOff - when last held note is released, turn gate CV to 0V
	// when doing that thru SC, may need a mono voicer model ...

*************


Port 3 is for CV1-2 input signals 0 to +5V
* input 1 is cc#112, chan 1,
* input 2 is cc 113, chan 1

Port 3 sends CV out on 0 to +5V
* Gate is noteOn/off -> 5V
* CV1 is pitch, i.e. pitch of the noteOn sent
* CV2 is mod on CC#1
* CV3 is pitchbend (on chan 0?)

m = MKtl(\qn3, "*qunexus_port3");
m.gui;
MKtlDesc.loadDescs("*qunexus_port3");
*/


///////// GENERIC information is in parentDesc ///////
(
parentDesc: "keith-mcmillen-qunexus",

///////// SPECIFIC INFORMATION for this port and config: ///////
	// port 3, CV in/outs get converted to/from MIDI

elementTypes: [\voltage],
status: (
	linux: "unknown",
	osx: "tested, without checking voltages, looks OK. 2016-03-17, adc",
	win: "unknown"),

idInfo: (deviceName: "QuNexus", srcPortIndex: 2, destPortIndex: 2),
portName: "Port 3",

elementsDesc: (
	shared: ('midiChan': 1),
	elements: [
		(
			// ins are any 2 CVs from 0 to 5V
			key: \cvIn,
			shared: (elementType: \cvIn, 'midiMsgType': 'cc', ioType: \in, 'spec': 'midiCC'),
			elements: [112, 113].collect { |ccnum| ('midiNum':  ccnum) }
		),

	// cvOut assumes a mono hardware synth with noteOn:
	// 1. noteOn opens gate CV to 5V
	// 2. midi noteNum of noteOn is converted to pitch CV
	// legato - is probably implemented in QuNexus already,
	// when QuN keys are used as CV control; should be:
	// if gate is already open, keep it open;
	// noteOff - when last held note is released, turn gate CV to 0V
	// when doing that thru SC, may need a mono voicer model ...

		(
			key: \cvOut,
			shared: (ioType: \out, elementType: \cvOut),
			elements: [
				// how to make a single note responder for all notes?
				// monophonic noteNumber of last new key pressed
				// so make one MKtlElement for all notes,
				// noteNum is held as value, held notes must be kept,
				// released notes are released, only send
				(
					key: \note,
					shared: (midiNum: \all, 'spec': 'midiVel'),
					elements: [
						(midiMsgType: \noteOn, key: \on),
						(midiMsgType: \noteOff, key: \off)
					]
				),
				(
					key: \mod,
					'midiMsgType': 'cc', 'midiNum':  1,'spec': 'midiCC'
				),
				(
					key: \bend, 'midiMsgType': 'bend', 'spec': 'midiBend'
				)
			]
		)
	]
)

);

