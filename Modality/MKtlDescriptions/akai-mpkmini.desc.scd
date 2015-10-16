// AKAI professional MPKmini Laptop Production Controller specs
// This desc file is made for the Factory Preset: Preset3-MPC,
// downloadable from "http://www.akaipro.com/product/mpkmini#downloads"
// made by Joost van Dalen

(
deviceName: "MPK mini",
protocol: \midi,
deviceType: \midiKeyboard,
elementTypes: [\pianoKey, \pads, \slider],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "MPK mini",

deviceInfo: (
	vendorURI: "http://www.akaipro.com/product/mpkmini",
	// manualURI: "",
	// description: "",
	features: [
		"25 key velocity-sensitive midiKeyboard",
		"8 backlit MPC-style pads",
		"8 Q-link knobs",
	],
	notes: "Desc file is made for the Factory Preset ```Preset3-MPC```, downloadable from http://www.akaipro.com/product/mpkmini#downloads",
	// hasScribble: false
),
description: (
	\bt: (midiMsgType: \cc,     elementType: \button, midiChan: 0, midiNum:      64, spec: \midiCC),
	\kn: (13..20).collect{ |midiNum|
		 (midiMsgType: \cc,     elementType: \knob,   midiChan: 0, midiNum: midiNum, spec: \midiCC)
	},
	\keyOn: (0..120).collect{ |note|
		(midiMsgType: \noteOn,  elementType: \key,    midiChan: 0, midiNum:    note, spec: \midiNote)
	},
	\keyOff: (0..120).collect{ |note|
		(midiMsgType: \noteOff, elementType: \key,    midiChan: 0, midiNum:    note, spec: \midiNote)
	},
	\padOn: #[[37,36,42,82,40,38,46,44],[48,47,45,43,49,55,51,53]].collect({ |bank|
		bank.collect{ |note|
			(midiMsgType: \noteOn,  elementType: \pad, midiChan: 9, midiNum:  note, spec: \midiNote)
	}}),
	\padOff: #[[37,36,42,82,40,38,46,44],[48,47,45,43,49,55,51,53]].collect({ |bank|
		bank.collect{ |note|
			(midiMsgType: \noteOff, elementType: \pad, midiChan: 9, midiNum:  note, spec: \midiNote)
	}}),
	\padCC: [(1..9),(10..17)].collect({ |bank|
		bank.collect{ |cc|
			(midiMsgType: \cc,      elementType: \pad, midiChan: 9, midiNum:    cc, spec: \midiCC)
	}})
)
)
