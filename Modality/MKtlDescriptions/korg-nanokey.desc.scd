/*
m = MKtl(\nky, "*nanokey"); m.gui;
*/

(
(
deviceName: "nanoKEY",
protocol: 'midi',
deviceType: \midiKeyboard,
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
elementsDesc: (
	shared: (midiChan: 0),
	elements: [
		(
			key: \pkey,
			elements: (0..120).collect { |midinum, i|
				MKtlDesc.notePair(i, midinum, style: (row: i div: 24, column: i % 24));
			}
		),
		(
			key: \mod,
			'midiMsgType': 'cc', 'elementType': 'button', 'midiNum': 1,'spec': 'midiBut'
		),
		// where do these come from? keys as cc?
		(
			key: \cc,
			shared: ('midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
			elements: ((14..31) ++ (80..87)).collect { |midinum, i|
				('midiNum': midinum)
			}
		),
		(
			key: \bend,
			'midiMsgType': 'bend', 'elementType': 'button', 'spec': 'midiBend'
		)
	]
)
)
)