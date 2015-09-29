// handmade from crappy MIDIExplorer.openDoc printout;
// should be compressed by default.

(
(
deviceName: "nanoKEY",
protocol: 'midi',
deviceType: \keyboard,
elementTypes: [\pianoKey],
status: (
	linux: "unknown",
	osx: "tested and working",
	win: "unknown"),

idInfo: "nanoKEY",

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",

	// hasScribble: false
),
description: (

	// ------ noteOnOff -------------
	//from 0-120
	'keyOn': (0..120).collect { |midinum| ('midiMsgType': 'noteOn', 'type': 'key', 'midiChan': 0, 'midiNum': midinum, 'spec': 'midiNote') },

	'keyOff': (0..120).collect { |midinum| ('midiMsgType': 'noteOn', 'type': 'key', 'midiChan': 0, 'midiNum': midinum, 'spec': 'midiNote') },

	mod: ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum': 1,'spec': 'midiBut'),
	// ------ cc -------------
	cc: ((14..31) ++ (80..87)).collect { |midinum|
		('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 0, 'midiNum': midinum,'spec': 'midiCC') },

	// ------- bend ------------
	'bend': ('midiMsgType': 'bend', 'type': 'buttons', 'midiChan': 0, 'midiNum':  0,'spec': 'midiBend')
);

));