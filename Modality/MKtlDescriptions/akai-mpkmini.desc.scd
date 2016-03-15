// AKAI professional MPKmini Laptop Production Controller specs
// This desc file is made for the Factory Preset: Preset3-MPC,
// downloadable from "http://www.akaipro.com/product/mpkmini#downloads"
// made by Joost van Dalen

/*
TODO:
* add gui layout


thisProcess.nowExecutingPath.basename.split($.).first.postcs;
d = MKtlDesc.loadDescs("*mpkmini").first;
d.web;

m.free; m = MKtl(\mpk, "*mpkmini"); m.gui;
m.trace;
m.elementsDict.size;
m.postElements;
*/

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
elementsDesc: (

	elements: [
		(
			key: \bt, midiMsgType: \cc, elementType: \button, midiChan: 0,
			midiNum: 64, spec: \midiCC),
		(
			key: \kn,
			shared: (midiMsgType: \cc, elementType: \knob, midiChan: 0,
				spec: \midiCC),
			elements: (13..20).collect { |midiNum| (midiNum: midiNum) }
		),
		(
			key: \pkey,
			shared: (elementType: \pianoKey, midiChan: 0, spec: \midiVel),
			elements: (0..120).collect { |note|
				MKtlDesc.notePair(midiNum: note) }
		),
		(
			key: \pad,
			shared: (elementType: \pad, midiChan: 9, spec: \midiVel),
			elements: #[
				[37,36,42,82,40,38,46,44],
				[48,47,45,43,49,55,51,53]
			].collect { |bank|
				(elements: bank.collect { |note|
					MKtlDesc.notePair(midiNum:  note)
				})
			}
		),
		(
			key: \padCC,
			shared: (elementType: \pad, midiChan: 9, spec: \midiVel),
			elements: [(1..9),(10..17)]
			.collect { |bank|
				( elements: bank.collect{ |cc|
					MKtlDesc.notePair(midiNum: cc)
				})
			}
		)
	]
)
)
