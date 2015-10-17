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
deviceType: \externalMidiPort,

status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: (deviceName: "QuNexus", sourcePortIndex: 1, destPortIndex: 1),
portName: "Port 2",

// this port is for connecting a MIDI device by midi plugs.
// you can:
// 1. Peave this empty and only use it to get the idInfo
//    for an MKtl made from the desc of an external device.
// 2. Copy this file, give it a joint name, and put the info
//    of your device there.

///// THis file is an example of 2:
// These are the elements for a decampo JoyStickBox,
// based on a PocketFader, 8 alps joysticks in 4x2 layout:

description: (
	joy: (0..7).collect { |i|
		i.asSymbol -> [
			\x -> (elementType: \joyAxis, midiMsgType: \control,
			midiChan: 0, midiNum: i * 2, spec: \midiCC),
			\y -> (elementType: \joyAxis, midiMsgType: \control,
			midiChan: 0, midiNum: i * 2 + 1, spec: \midiCC)
		];
	}
)
)
