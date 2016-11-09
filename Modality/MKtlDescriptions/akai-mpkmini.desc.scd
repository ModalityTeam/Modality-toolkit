// AKAI professional MPKmini Laptop Production Controller specs
// This desc file is made for the Factory Preset: Preset3-MPC,
// downloadable from "http://www.akaipro.com/product/mpkmini#downloads"
// made by Joost van Dalen

/*
TODO:
* add gui layout


thisProcess.nowExecutingPath.basename.split($.).first.postcs;
d = MKtlDesc.loadDescs("*mpkmini").first;

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
	osx: "tested desc only, gui missing, else ok. 2016-03-17",
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
	notes: "Uses factory preset [```Preset3-MPC```](http://www.akaipro.com/product/mpkmini#downloads)",
	longName: "AKAI MPKmini"
),
elementsDesc: (

	elements: [
		(
			key: \bt, midiMsgType: \cc, elementType: \button, midiChan: 0,
			midiNum: 64, spec: \midiBut),
		(
			key: \kn,
			shared: (midiMsgType: \cc, elementType: \knob, midiChan: 0,
				spec: \midiCC),
			elements: (13..20).collect { |midiNum, i|
				(midiNum: midiNum,
					style: (row: i div: 4, column: i % 4 + 4 + 1)
				)
			}
		),
		(
			key: \pkey,
			shared: (elementType: \pianoKey, midiChan: 0, spec: \midiVel),
			// was (0..120) - reduced it to likely default octave range
			elements: (48..72).collect { |note, i|
				var pos = Piano.pos(note, 48);
				(
					key: note,
					midiNum: note, groupType: \noteOnOff,
					shared: (groupType: \noteOnOff,
						style: (row: pos.y + 2, column: pos.x * 0.6, width: 0.8, color: pos.color)
					)
				)
			}
		),
		(
			key: \pad,
			shared: (elementType: \pad, midiChan: 9, spec: \midiVel),
			elements: #[
				[37,36,42,82,40,38,46,44],
				[48,47,45,43,49,55,51,53]
			].collect { |bank, i|
				(elements: bank.collect { |note, ii|
					(
						midiNum:  note, groupType: \noteOnOff,
						shared: (page: i, groupType: \noteOnOff,
							style: (row: 1 - (ii div: 4), column: ii % 4 + 1)
						)
					)
				})
			}
		),
		// // what do these do?
		// (
		// 	key: \padCC,
		// 	shared: (elementType: \pad, midiChan: 9, spec: \midiVel),
		// 	elements: [(1..9),(10..17)]
		// 	.collect { |bank|
		// 		(
		// 			elements: bank.collect { |note, ii|
		// 				(
		// 					midiNum:  note, groupType: \noteOnOff,
		// 					shared: (page: i, groupType: \noteOnOff,
		// 						style: (row: 1 - (ii div: 4), column: ii % 4 + 1)
		// 					)
		// 				)
		// 			}
		// 		)
		// 	}
		// )
	]
)
)
