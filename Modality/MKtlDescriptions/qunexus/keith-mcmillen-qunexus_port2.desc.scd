/*

General QuNexus info:
The QuNexus has 3 input ports, which have three separate desc files.
Its general info in is "keith-mcmillen-qunexus.parentDesc.scd".

This file is for Port 2 = portIndex 1.
This port is for the MIDI Expander in/output for connecting external MIDI hardware.
NOTE: One never needs to make an MKtl from this desc,
it is only for information purposes.

// For an example how to connect an external device thru a MIDI port, see:
"Connecting external MIDI devices".openHelpFile;
*/

(
///////// GENERIC INFORMATION COPIED TO ALL QUNEXUS DESC FILES: ///////
parentDesc: "keith-mcmillen-qunexus",

///////// SPECIFIC INFORMATION for this port and config: ///////

elementTypes: [],
deviceType: \externalMidiPort,

status: (
	linux: "unknown",
	osx: "tested desc only, without ext. device, looks ok. 2016-03-17, adc",
	win: "unknown"),

idInfo: (deviceName: "QuNexus", srcPortIndex: 1, destPortIndex: 1),
portName: "Port 2",

// port is for connecting external MIDI, so elementsDesc is empty.
elementsDesc: (
	elements: []
)

);
