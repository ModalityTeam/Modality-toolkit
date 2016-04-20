(
deviceName: "Logitech Extreme 3D_Logitech",
protocol: 'hid',
deviceType: \joystick,
elementTypes:  [\joystick, \button],
status: (
	linux: "unknown",
	osx: "tested desc, looks good. 2016_03_23, adc",
	win: "unknown"),

idInfo: "Logitech Extreme 3D_Logitech",

deviceInfo: (
	vendorURI: "http://gaming.logitech.com/en-us/product/extreme-3d-pro-joystick",
	manualURI: "http://support.logitech.com/product/extreme-3d-pro",
	longName: "Logitech Extreme 3D",
	// description: "",
	// features: [],
	// notes: "",

	hasScribble: true
),

elementsDesc: (
	elements: [
		(
			key: \bt,
			shared: ('hidUsagePage': 9, 'elementType': 'button',
				'ioType': 'in', 'spec': \hidBut ),
			elements: [
				(key: '1', 'hidUsage': 1),
				(key: '2', 'hidUsage': 2),
				(key: '2', 'hidUsage': 2),
				(key: '3', 'hidUsage': 3),
				(key: '4', 'hidUsage': 4),
				(key: '5', 'hidUsage': 5),

				(key: '6', 'hidUsage': 6),
				(key: '7', 'hidUsage': 7),
				(key: '8', 'hidUsage': 8),
				(key: '9', 'hidUsage': 9),

				(key: '10', 'hidUsage': 10),
				(key: '11', 'hidUsage': 11),
				// on base, center
				(key: '12', 'hidUsage': 12)
			],
		),
		(
			key: \joy,
			shared: ('hidUsagePage': 1, 'elementType': 'joyAxis', 'ioType': 'in', 'spec': \cent1),
			elements: [
				(key: \x, 'hidUsage': 48),
				(key: \y, 'hidUsage': 49),
				(key: \z, 'hidUsage': 53)
			]
		),
		(
			key: \hat,
			'hidUsage': 57, 'hidUsagePage': 1, 'elementType': 'hatSwitch',
			'ioType': 'in', spec: \cent1inv, mode: \center),
		(
			key: \slider,
			'hidUsage': 54, 'hidUsagePage': 1, 'elementType': 'slider',
			'ioType': 'in', spec: \cent1inv, mode: \center
		)
	]
)
);
