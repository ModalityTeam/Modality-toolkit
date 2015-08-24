/*

QuNexus has 3 input ports:
Port 1, index 0 is the keys and control on the QuNexus itself

Port 2 is used for the MIDI Expander input

Port 3 is for CV1-2 input signals 0 to +5V
* input 1 is cc#112, chan 1,
* input 2 is cc 113, chan 1

Output ports use the same numbering scheme:
Port 1 is for sending values to the MIDI keys on the QuNexus ?
Port 2 sends CV out on 0 to +5V
* Gate is noteOn/off -> 5V
* CV1 is pitch, i.e. pitch of the noteOn sent
* CV2 is mod on CC#1
* CV3 is pitchbend (on chan 0?)

(
idInfo: "QuNexus", // every port registers with this name
protocol: \midi,
ports


TODO:

QuNexus has four modes:
	Preset A uses just noteOn/Off and channel bend
	Preset B adds channel pressure
	Preset C allocates notes to 10 rotating midi chans,
		and sends poly bend and pressure mod (cc1) on those chans
	Preset D is for drums (uses chan 10) and clips

see Tests/QuNexus.scd
*/



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
description: (

	// Preset A mode has these:
// ------ noteOn -------------

	keyOn: (24..108).collect { |midinote|
	('midiMsgType': 'noteOn', 'type': 'key', 'midiChan': 0, 'midiNum':  midinote, 'spec': 'midiNote') },
	// ---------noteOff ----------
	keyOff: (24..108).collect { |midinote|
		('midiMsgType': 'noteOff', 'type': 'key', 'midiChan': 0, 'midiNum':  midinote, 'spec': 'midiNote')
	},

// ------- bend ------------
	'bend': ('midiMsgType': 'bend', 'type': 'bender', 'midiChan': 0, 'midiNum':  0,'spec': 'midiBend'),

// Preset B mode adds single channel pressure from all keys :

// ------- cc ------------
'monotouch': ('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 0, 'midiNum':  1,'spec': 'midiCC'),
)

// Preset C mode adds Poly Pitch Bend on up to 10 channels rotating,
// plus pressure on cc1 (also rotating?)

// Preset D mode for drums and clips

);
