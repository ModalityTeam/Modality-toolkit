/*

General QuNexus info:
The QuNexus has 3 input ports, which require three separate desc files.
Its general info in is "keith-mcmillen-qunexus.parentDesc.scd".

This file is for Port 1, portIndex 0, and Presets A and B.

On this port and in these modes, the keys and control on the QuNexus itself
can be played into the computer and set from it.

	Preset A uses just noteOn/Off and channel bend,
	Preset B adds channel pressure - so only use Preset B.
*/

(
///////// GENERIC INFORMATION COPIED TO ALL QUNEXUS DESC FILES: ///////
parentDesc: "keith-mcmillen-qunexus",

///////// SPECIFIC INFORMATION for this port and config: ///////

elementTypes: [\pianoKey, \bender, \touch],
status: (
	linux: "unknown",
	osx: "tested and working",
	win: "unknown"),

idInfo: (deviceName: "QuNexus", sourcePortIndex: 0, destPortIndex: 0),
portName: "Port 1",
modeName: "Preset AB",

elementsDesc: (
	sharedProperties: ('midiChan': 0, preset: \B),

	// Preset B has the same elements as Preset A, and single channel pressure.
	elements: [
		(
			key: \pianoKey,
			sharedProperties: ('midiMsgType': 'noteOnOff', 'elementType': 'pianoKey', 'spec': 'midiVel')
			elements: (24..108).collect { |midinote|
				('midiNum':  midinote)
			}
		),
		(
			key: 'bend',
			'midiMsgType': 'bend', 'elementType': 'bender', 'midiNum':  0,'spec': 'midiBend'
		),
		// Preset B mode only adds single channel pressure from all keys
		(
			key: 'monotouch',
			'midiMsgType': 'cc', 'elementType': 'keyTouch', 'midiNum':  1,'spec': 'midiCC')
	]
)
)
