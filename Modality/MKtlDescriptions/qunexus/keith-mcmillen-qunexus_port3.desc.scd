/*

This file is for Port 3, portIndex 2.
On this port, one can send and measure control voltage,
such as from modular synthesizers.

Port 3 is for CV1-2 input signals 0 to +5V
* input 1 is cc#112, chan 1,
* input 2 is cc 113, chan 1

Port 3 sends CV out on 0 to +5V
* Gate is noteOn/off -> 5V
* CV1 is pitch, i.e. pitch of the noteOn sent
* CV2 is mod on CC#1
* CV3 is pitchbend (on chan 0?)

*/


///////// GENERIC INFORMATION COPIED TO ALL QUNEXUS DESC FILES: ///////
(
deviceName: "QuNexus",
protocol: \midi,
numPorts: 3,

///////// SPECIFIC INFORMATION for this port and config: ///////
	// port 3, CV in/outs get converted to/from MIDI

idInfo: (deviceName: "QuNexus", sourcePortIndex: 2, destPortIndex: 2),
portName: "Port 3",

description: (

	// ins are any 2 CVs from 0 to 5V
	cvIn: [112, 113].collect { |ccnum|
		(type: \cvIn, 'midiMsgType': 'cc', 'midiChan': 1, ioType: \in,
			'midiNum':  ccnum,'spec': 'midiCC')
	},

	// cvOut assumes a mono hardware synth with noteOn:
	// 1. noteOn opens gate CV to 5V
	// 2. midi noteNum of noteOn is converted to pitch CV
	// legato - is probably implemented in QuNexus already,
	// when QuN keys are used as CV control; should be:
	// if gate is already open, keep it open;
	// noteOff - when last held note is released, turn gate CV to 0V
	// when doing that thru SC, may need a mono voicer model ...

	cvOut: (
		// how to make a single note responder for all notes?
		// monophonic noteNumber of last new key pressed
		// so make one MKtlElement for all notes,
		// noteNum is held as value, held notes must be kept,
		// released notes are released, only send

		note: (type: \cvOut, 'midiMsgType': 'noteOnOff', 'midiChan': 1, ioType: \out,
			midiNum: \all, 'spec': 'midiCC'),
		mod: (type: \cvOut, 'midiMsgType': 'cc', 'midiChan': 1, ioType: \out,
			'midiNum':  1,'spec': 'midiCC'),
		bend: (type: \cvOut, 'midiMsgType': 'bend', 'midiChan': 1, ioType: \out,
			'spec': 'midiBend')
	)
)

);
