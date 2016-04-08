/*

General QuNexus info:
The QuNexus has 3 input ports, which require three separate desc files.
Its general info in is "keith-mcmillen-qunexus.parentDesc.scd".

This file is for Port 1, portIndex 0, and Preset C.

In this mode, the QuNexus allocates notes to 10 rotating midi chans,
and sends poly bend and pressure mod (cc1) on those chans.
this is not directly supported by MOdality yet;
to be adapted from an example for the Roli keyboard soon.

*/

(
///////// GENERIC INFORMATION COPIED TO ALL QUNEXUS DESC FILES: ///////

parentDesc: "keith-mcmillen-qunexus",

///////// SPECIFIC INFORMATION for this port and config: ///////

elementTypes: [\pianoKeyChan, \bend, \keyTouch],
status: (
	linux: "not done yet",
	osx: "not done yet",
	win: "not done yet"),

idInfo: (deviceName: "QuNexus", srcPortIndex: 0, destPortIndex: 0),
portName: "Port 1",
modeName: "Preset C",


description: (

	// Preset C mode is the most interesting:
	// it adds Poly Pitch Bend on up to 10 channels rotating,
	// plus pressure on cc1, which also rotates.
	// how to make a special MKtl for it?
	// see the Roli example ... to be adapted soonish.
	// add page: \C to all elements
)
);
