(
deviceName: "USB Joystick_MegaWorldectronics",
protocol: \hid,
deviceType: \joystick,
elementTypes: [\joystick, \button, \hat, \slider],
status: (
	linux: "unknown",
	osx: "tested desc, looks good. 2016_03_23, adc",
	win: "unknown"),

idInfo: "USB Joystick_MegaWorldectronics",

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",

	longName: "ThrustMaster joystick"
),
elementsDesc: (
	elements: [
		(
			key: \bt,
			shared: ('hidUsagePage': 9, 'elementType': 'button', 'ioType': 'in',spec: \hidBut ),
			elements: [
				(key: \1, 'hidUsage': 1),
				(key: \2, 'hidUsage': 2),
				(key: \3, 'hidUsage': 3),
				(key: \4, 'hidUsage': 4),
			]
		),
		(
			key: 'hat',
			'hidUsage': 57, 'hidUsagePage': 1, 'elementType': 'hatSwitch',
			'ioType': 'in', spec: \cent1, mode: \center),
		(
			key: \joy,
			shared: ('hidUsagePage': 1, 'elementType': 'joyAxis', 'ioType': 'in',
				spec: \cent1, mode: \center ),
			elements: [
				(key: \x, 'hidUsage': 48),
				(key: \y, 'hidUsage': 49)
			]
		),
		(
			key: 'sl', 'hidUsage': 187, 'hidUsagePage': 2, 'elementType': 'slider',
			'ioType': 'in', spec: \cent1, mode: \center )
	]
)
)