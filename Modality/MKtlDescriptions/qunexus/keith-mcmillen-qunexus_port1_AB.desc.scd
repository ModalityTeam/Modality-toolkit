/*

General QuNexus info:
The QuNexus has 3 input ports, which require three separate desc files.
Its general info in is "keith-mcmillen-qunexus.parentDesc.scd".

This file is for Port 1, portIndex 0, and Presets A and B.

On this port and in these modes, the keys and control on the QuNexus itself
can be played into the computer and set from it.

	Preset A uses just noteOn/Off and channel bend,
	Preset B adds channel pressure.
*/

(
///////// GENERIC INFORMATION COPIED TO ALL QUNEXUS DESC FILES: ///////
idInfo: "QuNexus",
protocol: \midi,
parentDesc: "keith-mcmillen-qunexus",
numPorts: 3,

///////// SPECIFIC INFORMATION for this port and config: ///////

portIndex: 0,
portName: "Port 1",
modeName: "Preset AB",

description: (

	// Preset B has the same elements as Preset A, and some more - like Preset A:
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
'monotouch': ('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 0, 'midiNum':  1,'spec': 'midiCC')
)
)
