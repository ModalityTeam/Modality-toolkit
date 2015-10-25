/*
The RME Fireface 400 has two external MIDI ins and outs.
On OSX, it registers these as (for example):
"Fireface 400 (297)", "Port 1",
"Fireface 400 (297)", "Port 2",
where the "(297)" is an individual ID/serial number for each Fireface.
*/

(
///////// GENERIC INFORMATION COPIED TO ALL QUNEXUS DESC FILES: ///////
parentDesc: "rme-audio-fireface-400",

///////// SPECIFIC INFORMATION for this port and config: ///////

elementTypes: [],
deviceType: \externalMidiPort,

status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: (deviceName: "Fireface 400*", sourcePortIndex: 1, destPortIndex: 1),
portName: "Port 2",

// port is for connecting a MIDI device by midi plugs,
// so you can put the info of your device in copies of this file,
// or plug it in from the desc file of a MIDI-only device.
elementsDesc: (
	elements: []
)
);
