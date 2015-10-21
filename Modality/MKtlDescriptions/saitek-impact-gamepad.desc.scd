/*
ToDO:
* check output elements - LEDs?
* make little example.
* copy gui layout from Ferrari

MKtlDesc.openFolder;

*/

MKtl.addSpec(\compassImpact, [0, 1.0]);

(
deviceName: "USB Game Controllers_Mega World",
protocol: 'hid',
deviceType: \gamepad,
elementTypes: [\joystick, \button, \compass],
status: (
	linux: "unknown",
	osx: "tested and working",
	win: "unknown"),

idInfo: "USB Game Controllers_Mega World",

specs: (compassImpact: [0, 7, \lin, 1].asSpec),

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",

	// hasScribble: false
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
				(key: \5, 'hidUsage': 5),
				(key: \6, 'hidUsage': 6),
				(key: \7, 'hidUsage': 7),
				(key: \8, 'hidUsage': 8),
				(key: \9, 'hidUsage': 9),
				(key: \10, 'hidUsage': 10),
				(key: \11, 'hidUsage': 11),
				(key: \12, 'hidUsage': 12)
			]
		),
		(
			key: 'compass',
			'hidUsage': 57, 'hidUsagePage': 1, 'elementType': 'compass', 'ioType': 'in', spec: \compassImpact
		),
		(
			key: \joy,
			shared: ('hidUsagePage': 1, 'elementType': 'joyAxis', 'ioType': 'in',
				spec: \cent1, mode: \center ),
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

// --------- output elements ----------
	// '<element name undefined>': ('hidUsage': 67, 'hidUsagePage': 8, 'elementType': '<type Led>', 'ioType': 'out' ),
	// '<element name undefined>': ('hidUsage': 68, 'hidUsagePage': 8, 'type': '<type Led>', 'ioType': 'out' ),
	// '<element name undefined>': ('hidUsage': 69, 'hidUsagePage': 8, 'type': '<type Led>', 'ioType': 'out' ),
	// '<element name undefined>': ('hidUsage': 70, 'hidUsagePage': 8, 'type': '<type Led>', 'ioType': 'out' ),
)
);