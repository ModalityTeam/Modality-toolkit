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
	sharedProperties: (midiChan: 0),
	elements: [
		(
			key: \pkey,
			elements: (0..120).collect { |midinum|
				('midiMsgType': 'noteOnOff', 'elementType': 'key', 'midiNum': midinum, 'spec': 'midiVel')
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
