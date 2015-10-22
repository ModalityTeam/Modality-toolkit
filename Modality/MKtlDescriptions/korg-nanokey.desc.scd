
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
			elements: (0..120).collect { |midinum|
				('midiMsgType': 'noteOnOff', 'elementType': 'key', 'midiNum': midinum, 'spec': 'midiVel')
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