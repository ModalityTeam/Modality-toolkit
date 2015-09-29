/*
MKtl.deviceDescriptionFolder.openOS
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
description: (


// --------- input elements ----------
	'joy': (
		'l': (
			'x': ('hidUsage': 48, 'hidUsagePage': 1, 'type': 'joyAxis', 'ioType': 'in', spec: \cent1, mode: \center ),
			'y': ('hidUsage': 49, 'hidUsagePage': 1, 'type': 'joyAxis', 'ioType': 'in', spec: \cent1, mode: \center )
		),
		'r': (
			'y': ('hidUsage': 50, 'hidUsagePage': 1, 'type': 'joyAxis', 'ioType': 'in', spec: \cent1, mode: \center ),
			'x': ('hidUsage': 53, 'hidUsagePage': 1, 'type': 'joyAxis', 'ioType': 'in', spec: \cent1, mode: \center ),
		)
	),
	'bt': (
		1: ('hidUsage': 1, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in',spec: \hidBut ),
		2: ('hidUsage': 2, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in',spec: \hidBut ),
		3: ('hidUsage': 3, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in',spec: \hidBut ),
		4: ('hidUsage': 4, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in',spec: \hidBut ),
		5: ('hidUsage': 5, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in',spec: \hidBut ),
		6: ('hidUsage': 6, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in',spec: \hidBut ),
		7: ('hidUsage': 7, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in',spec: \hidBut ),
		8: ('hidUsage': 8, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in',spec: \hidBut ),
		9: ('hidUsage': 9, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in',spec: \hidBut ),
		10: ('hidUsage': 10, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in',spec: \hidBut ),
		11: ('hidUsage': 11, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in',spec: \hidBut ),
		12: ('hidUsage': 12, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in',spec: \hidBut )
	),

	'compass': ('hidUsage': 57, 'hidUsagePage': 1, 'type': 'compass', 'ioType': 'in', spec: \compassImpact ),

// --------- output elements ----------
	// '<element name undefined>': ('hidUsage': 67, 'hidUsagePage': 8, 'type': '<type Led>', 'ioType': 'out' ),
	// '<element name undefined>': ('hidUsage': 68, 'hidUsagePage': 8, 'type': '<type Led>', 'ioType': 'out' ),
	// '<element name undefined>': ('hidUsage': 69, 'hidUsagePage': 8, 'type': '<type Led>', 'ioType': 'out' ),
	// '<element name undefined>': ('hidUsage': 70, 'hidUsagePage': 8, 'type': '<type Led>', 'ioType': 'out' ),
)
);