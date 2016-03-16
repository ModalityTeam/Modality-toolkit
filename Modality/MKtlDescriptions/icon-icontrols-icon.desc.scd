(
deviceName: "iCON iControls V2.00_iCON",
protocol: 'hid',
deviceType: \joystick,
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),
elementTypes: [\joyAxis],

idInfo: "iCON iControls V2.00_iCON",

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",

	// hasScribble: false
),
elementsDesc: (
	shared: ( hidUsagePage: 1, type: 'joyAxis', ioType: 'in', spec: 'mouseAxis' ),
	elements: [
		(key: 'x', hidUsage: 48),
		(key: 'y', hidUsage: 56)
	]
)
)

// --------- input elements ----------
	/* what is the state of these?

'<element name b0>': ('hidUsage': 0, 'hidUsagePage': 9, 'type': '<type Button>', 'ioType': 'in' ),
'<element name b1>': ('hidUsage': 1, 'hidUsagePage': 9, 'type': '<type Button>', 'ioType': 'in' ),
'<element name b2>': ('hidUsage': 2, 'hidUsagePage': 9, 'type': '<type Button>', 'ioType': 'in' ),
'<element name b3>': ('hidUsage': 3, 'hidUsagePage': 9, 'type': '<type Button>', 'ioType': 'in' ),

//'x': (hidUsage: 49, hidUsagePage: 1, type: 'mouseAxis', ioType: 'in', spec: 'mouseAxis' ),
	*/
