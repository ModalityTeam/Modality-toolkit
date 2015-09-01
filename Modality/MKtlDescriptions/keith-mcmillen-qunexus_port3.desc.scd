/*

General QuNexus info:

QuNexus has 3 input ports, which require three separate desc files.
As the QuNexus also has four preset modes for port 1, there are
seven separate desc files - please choose the one for your usage.
You can load all of them into separate MKtls, andput the different
functionalities there.

These are the port specifics:

Port 1, index 0 is the keys and control on the QuNexus itself
	the elements on this port have four preset modes, see below

Port 2 is used for the MIDI Expander input

Port 3 is for CV1-2 input signals 0 to +5V
* input 1 is cc#112, chan 1,
* input 2 is cc 113, chan 1

Output ports use the same numbering scheme:
Port 1 is for sending values to the MIDI keys on the QuNexus

Port 2 is used for the MIDI Expander output 5pin plug

Port 3 sends CV out on 0 to +5V
* Gate is noteOn/off -> 5V
* CV1 is pitch, i.e. pitch of the noteOn sent
* CV2 is mod on CC#1
* CV3 is pitchbend (on chan 0?)


QuNexus has four hardware modes, which concern port 1:

	Preset A uses just noteOn/Off and channel bend
	Preset B adds channel pressure
	Preset C allocates notes to 10 rotating midi chans,
		and sends poly bend and pressure mod (cc1) on those chans
	Preset D is for drums (uses chan 10) and clips
*/


///////// GENERIC INFORMATION COPIED TO ALL QUNEXUS DESC FILES: ///////
(
idInfo: "QuNexus",
protocol: \midi,

deviceInfo: (

	vendorURI: "http://www.keithmcmillen.com/products/qunexus/",
	manualURI: "http://www.keithmcmillen.com/downloads#qunexus",
	// description: "",
	features: [
		"25 LED backlit keys with pressure and tilt sensitivity",
		"Pitch bend pad",
		"Octave up/down buttons",
		"5 function buttons",
	],
	// notes: "",
	type: [\button, \keyboard],
	// hasScribble: false
),



///////// SPECIFIC INFORMATION for this port and config: ///////
	// port 3, CV in/outs get converted to/from MIDI

portName: "Port 3",


description: (

	// ins are any 2 CVs from 0 to 5V
	cvIn: [112, 113].collect { |ccnum|
		('midiMsgType': 'cc', 'midiChan': 1, ioType: \in,
			'midiNum':  ccnum,'spec': 'midiCC')
	},

	// cvOut assumes a mono hardware synth with noteOn:
	// 1. noteOn opens gate CV to 5V
	// 2. midi noteNum of noteOn is converted to pitch CV
	// legato - is probably implemented in QuNexus already,
	// when QuN keys are used as CV control; should be:
	// if gate is already open, keep it open;
	// noteOff - when last held note is released, turn gate CV to 0V
	// when doing that thru SC, needs a mono voicer model ...

	cvOut: (
		// how to make a single note responder for all notes?
		// monophonic noteNumber of last new key pressed
		// so make one MKtlElement for all notes,
		// noteNum is held as value, held notes must be kept,
		// released notes are released, only send

		note: ('midiMsgType': 'noteOnOff', 'midiChan': 1, ioType: \out,
			noteNum: \all, 'spec': 'midiCC'),
		mod: ('midiMsgType': 'cc', 'midiChan': 1, ioType: \out,
			'midiNum':  1,'spec': 'midiCC'),
		bend: ('midiMsgType': 'bend', 'midiChan': 1, ioType: \out,
			'spec': 'midiBend')
	)
)

);
