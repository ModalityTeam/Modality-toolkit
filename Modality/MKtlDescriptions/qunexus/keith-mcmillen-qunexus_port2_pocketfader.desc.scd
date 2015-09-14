/*

General QuNexus info:
The QuNexus has 3 input ports, which require three separate desc files.
Its general info in is "keith-mcmillen-qunexus.parentDesc.scd".

This file is for Port 2 = portIndex 1.
This port is for the MIDI Expander in/output,
so one can connect any external MIDI hardware device;
the elements would then represent this connected device.

*/

(
///////// GENERIC INFORMATION COPIED TO ALL QUNEXUS DESC FILES: ///////
parentDesc: "keith-mcmillen-qunexus",

///////// SPECIFIC INFORMATION for this port and config: ///////

elementTypes: [\joyAxis],

status: "untested",
idInfo: (deviceName: "QuNexus", sourcePortIndex: 0, destPortIndex: 0),
portName: "Port 2",

// port is for connecting a MIDI device by midi plugs,
// so put the info of your device in copies of this file.

// here, these are the elements for a Doepfer PocketFader:
description: (
	sl: (0..15).collect { |i|
		(elementType: \slider, midiMsgType: \control,
			midiChan: 0, midiNum: i, spec: \midiCC)
	}
)
)

);
