/*
m = MKtl(\nky2, "*microkey"); m.gui;
*/
(
deviceName: "microKEY",
protocol: 'midi',
deviceType: \midiKeyboard,
elementTypes: [\pianoKey],
status: (
	linux: "unknown",
	osx: "tested desc, looks good. gui needs info. 2016_03_23, adc",
	win: "unknown"),

idInfo: "microKEY",

deviceInfo: (
	vendorURI: "http://www.korg.com/us/products/controllers/microkey/",
	// manualURI: "",
	// description: "",
	features: [
		"Velocity-sensitive mini-midiKeyboard",
		"three models: 25-key / 37-key / 61-key"
	],
	longName: "KORG microKEY"
	// notes: "",
),
elementsDesc: (
	shared: ('midiChan': 0),
	elements: [
		(
			key: \pkey,
			shared: ('elementType': 'pianoKey', spec: \midiVel),
			elements: (0..120).collect { |midinum, i|
				MKtlDesc.notePair(i, midinum,
					(style: (row: i div: 24, column: i % 24))
				);
			}
		),
		(
			key: 'mod',
			'midiMsgType': 'cc', 'elementType': 'modWheel', 'midiNum': 1,
			'spec': 'midiCC'),
		(
			key: 'bend',
			'midiMsgType': 'bend', 'elementType': 'bender',
			'spec': 'midiBend'
		)
	]
)
);