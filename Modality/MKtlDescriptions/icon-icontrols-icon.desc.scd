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
	vendorURI: "http://www.icon-global.com/Controllers_MIDI+recording+controllers_iControls+.htm",
	manualURI: "http://www.icon-global.com/download%5Cuser%20manual%5CIC%20PD3V1.00-E.zip",
	// description: "",
	// features: [],
	notes: "This device also has a MIDI interface. Hat-switch is not sending any data.",

	// hasScribble: false
),
//nescivi: spec is a bit tricky to get right, but this comes close
specs: ( \mouseAxisIcon: [ 0.46062994003296, 0.53937005996704, \lin, 0, 0.5].asSpec ),
elementsDesc: (
	shared: ( hidUsagePage: 1, type: 'mouseAxis', ioType: 'in', spec: 'mouseAxisIcon', mode: \center ),
	elements: [
		(key: 'x', hidUsage: 48),
		(key: 'y', hidUsage: 49)
	]
)
)

// --------- input elements ----------
	/* what is the state of these?
They are defined in the device (HID descriptor), but not physically present)

'<element name b0>': ('hidUsage': 0, 'hidUsagePage': 9, 'type': '<type Button>', 'ioType': 'in' ),
'<element name b1>': ('hidUsage': 1, 'hidUsagePage': 9, 'type': '<type Button>', 'ioType': 'in' ),
'<element name b2>': ('hidUsage': 2, 'hidUsagePage': 9, 'type': '<type Button>', 'ioType': 'in' ),
'<element name b3>': ('hidUsage': 3, 'hidUsagePage': 9, 'type': '<type Button>', 'ioType': 'in' ),

//'sync': (hidUsage: 56, hidUsagePage: 1, type: 'mouseAxis', ioType: 'in', spec: 'mouseAxis' ),
	*/
