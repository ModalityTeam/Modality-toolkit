/*
m = MKtl(\nky2, "*key2"); m.gui;
*/
(
deviceName: "nanoKEY2",
protocol: 'midi',
deviceType: \midiKeyboard,
elementTypes: [\pianoKey, \button],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "nanoKEY2",

deviceInfo: (
	vendorURI: "http://www.korg.com/us/products/controllers/nanokey2/",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",

),
elementsDesc: (
	shared: (midiChan: 0),
	elements: [
		(
			key: \pkey,
			shared: ('elementType': 'pad', 'spec': 'midiVel'),
			elements: (0..120).collect { |midinum, i|
				MKtlDesc.notePair(i, midinum,
					(style: (row: i div: 24, column: i % 24))
				);
			}
		),
		(
			key: \mod, 'midiNum': 1,
		'midiMsgType': 'cc', 'elementType': 'button', spec: 'midiBut'
		),
		(
			key: \, 'midiNum': 1,
		'midiMsgType': 'cc', 'elementType': 'button', spec: 'midiBut'
		),
		(
			key: \bend,
			'midiMsgType': 'bend', 'elementType': 'button', 'spec': 'midiBend'
		)
	]
)
);
