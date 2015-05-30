/*
See Examples:QuNexus
*/

(
idInfo: "QuNexus",
protocol: \midi,
port: 0,
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
'touch': ('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 0, 'midiNum':  1,'spec': 'midiCC'),
)

// Preset C mode adds Poly Pitch Bend on up to 10 channels rotating,
// plus pressure on cc1 (also rotating?)

// Preset D mode for drums and clips

);
