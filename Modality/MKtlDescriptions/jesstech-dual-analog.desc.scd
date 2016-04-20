(
deviceName: "Dual Analog Pad_Jess Tech",
protocol: \hid,
deviceType: \gamepad,
elementTypes: [\button, \joyAxis, \hat],
status: (
	linux: "unknown",
	osx: "tested desc, looks good. 2016_03_23, adc",
	win: "unknown"),

idInfo: "Dual Analog Pad_Jess Tech",

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	// description: "",
	// features: [],
	longName: "Jess Tech Dual Analog Pad"

),

elementsDesc: (
	elements: [
		(
			key: \bt,
			shared: ('hidUsagePage': 9, 'elementType': 'button', 'ioType': 'in',spec: \hidBut ),
			elements: [
				(key: \1, 'hidUsage': 5),
				(key: \2, 'hidUsage': 6),
				(key: \3, 'hidUsage': 7),
				(key: \4, 'hidUsage': 8),
				(key: \5, 'hidUsage': 9),
				(key: \6, 'hidUsage': 10),
				(key: \7, 'hidUsage': 11),
				(key: \8, 'hidUsage': 12),
				(key: \9, 'hidUsage': 16),
			]
		),
		(
			key: 'hat', elementType: \hatSwitch,
			'hidUsage': 57, 'hidUsagePage': 1, 'type': 'hatSwitch',
			'ioType': 'in', spec: \cent1, mode: \center
		),
		(
			key: \joy,
			shared: ('hidUsagePage': 1, 'elementType': 'joyAxis',
				'ioType': 'in', spec: \cent1, mode: \center ),
			elements: [
				(key: \l,
					elements: [
						(key: \x, 'hidUsage': 48),
						(key: \y, 'hidUsage': 49)
					]
				),
				(key: \r,
					elements: [
						(key: \x, 'hidUsage': 50),
						(key: \y, 'hidUsage': 53)
					]
				)
			]
		),
	]
)
)