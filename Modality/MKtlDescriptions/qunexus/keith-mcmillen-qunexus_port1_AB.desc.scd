/*

// test this desc:
~thisdesc = thisProcess.nowExecutingPath.basename.split($.).first.postcs;
d = MKtlDesc.loadDescs(~thisdesc).first;
d.web;

// close old m, open new one, make gui:
m.free; m = MKtl(\qn_ab, "*qunexus_port1_AB"); m.gui;
m.trace;
m.elementsDict.size;
m.postElements;


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
	osx: "tested and working, 2016-03-16, adc",
	win: "unknown"),

idInfo: (deviceName: "QuNexus", sourcePortIndex: 0, destPortIndex: 0),
portName: "Port 1",
modeName: "Preset AB",

elementsDesc: (
	shared: ('midiChan': 0, preset: \B),

	// Preset B has the same elements as Preset A, and single channel pressure.
	elements: [
		(
			key: \pk,
			shared: ('elementType': 'pad', 'spec': 'midiVel'),
			elements: (24..108).collect { |midinote, i|
				var xindex = i % 24, yindex = i div: 24;
				var octDists = [0, 7] +.x [0, 0.5, 1, 1.5, 2, 3, 3.5, 4, 4.5, 5, 5.5, 6];
				var xpos = octDists[xindex];
				var ypos = yindex - (xpos.frac * 0.9) + 0.5 * 2;

				MKtlDesc.notePair(i, midinote,
					(style: (row: ypos, column: xpos * 0.6, width: 0.7))
				)
			}
		),
		(
			key: 'bend',
			'midiMsgType': 'bend', 'elementType': 'bender', 'midiNum':  0,'spec': 'midiBend'
		),
		// Preset B mode only adds single channel pressure from all keys
		(
			key: 'monotouch',
			'midiMsgType': 'cc', 'elementType': 'keyTouch', 'midiNum':  1,'spec': 'midiCC'
		)
	]
)
)
