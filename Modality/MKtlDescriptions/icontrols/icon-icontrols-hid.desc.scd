(
deviceName: "iCON iControls V2.00_iCON",
protocol: 'hid',
deviceType: \joystick,
status: (
	linux: "tested and working, 2016_03_20 by nescivi",
	osx: "tested desc, looks good. 2016_03_23, adc",
	win: "unknown"),
elementTypes: [\joyAxis],

idInfo: "iCON iControls V2.00_iCON",

deviceInfo: (
	vendorURI: "http://icon-global.com/product/icontrols/",
	manualURI: "http://support.icon-global.com/hc/en-us/articles/216201337-iControls",
	// description: "",
	// features: [],
	notes: "This desc only implements the joystick of the device.",
	longName: "iCON iControls (HID)"
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
