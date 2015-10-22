(
deviceName: "microKEY",
protocol: 'midi',
deviceType: \midiKeyboard,
elementTypes: [\pianoKey],
status: (
	linux: "unknown",
	osx: "unknown",
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
	// notes: "",
),
elementsDesc: (
	shared: ('midiChan': 0),
	elements: [
		(
			key: \pkey,
			shared: ('midiMsgType': 'noteOnOff', 'elementType': 'pianoKey',
				spec: \midiVel),
			elements: (0..120).collect { arg i; ('midiNum':  i) }
		),
		(
			key: 'mod',
			'midiMsgType': 'cc', 'elementType': 'wheel', 'midiNum': 1,
			'spec': 'midiCC'),
		(
			key: 'bend',
			'midiMsgType': 'bend', 'elementType': 'bender',
			'spec': 'midiBend'
		)
	]
)
);