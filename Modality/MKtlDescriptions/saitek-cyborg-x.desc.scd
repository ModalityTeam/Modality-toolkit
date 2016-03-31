/*
compass on Saitek Joystick has these deviceValues
15: center
1: up
3: right
5: down
7: left.

how to map that in a spec? see saitek-impact-gamepad.desc

*/
(
deviceName: "Cyborg X_Saitek",
deviceType: \joystick,
idInfo: "Cyborg X_Saitek",
protocol: 'hid',
status: (
	linux: "unknown",
	osx: "tested and working. 2016-03-17, adc",
	win: "unknown"),


deviceInfo: (
	// vendorURI: "http://",
	// manualURI: "http://",
	// description: "",
	// features: [
	// ],
	longName: "Saitek Cyborg X"
),

elementsDesc: (
	shared: ('ioType': 'in'),
	elements: [
		(
			key: \trig,
			'hidUsage': 1, 'hidUsagePage': 9, 'elementType': 'trigger', 'spec': \hidBut
		),
		(
			key: \bt,
			shared: ('hidUsagePage': 9, 'elementType': 'button', 'spec': \hidBut ),
			elements: [
				// buttons on joyHead
				(key: '2', 'hidUsage': 2),
				(key: '3', 'hidUsage': 3),
				(key: '4', 'hidUsage': 4),
				(key: '5', 'hidUsage': 5),

				// on base left
				(key: '6', 'hidUsage': 6),
				(key: '7', 'hidUsage': 7),
				(key: '8', 'hidUsage': 8),
				(key: '9', 'hidUsage': 9),

				// on left foot
				(key: '10', 'hidUsage': 10),
				(key: '11', 'hidUsage': 11),
				// on base, center
				(key: '14', 'hidUsage': 14)
			],
		),
		(
			key: \scroll,
			shared: ('hidUsagePage': 9, 'elementType': 'scroller', 'spec': \hidBut),
			elements: [
				(	key: \up, 'hidUsage': 12),
				(	key: \down, 'hidUsage': 13),
			]
		),
		(
			key: \joy,
			shared: ('hidUsagePage': 1, 'elementType': 'joyAxis', 'spec': \cent1),
			elements: [
				(key: \x, 'hidUsage': 48),
				(key: \y, 'hidUsage': 49),
				(key: \rot, 'hidUsage': 53)
			]
		),
		(
			key: \compass, 'hidUsage': 57, 'hidUsagePage': 1, 'elementType': 'compass',
			spec: \unipolar
		),
		(
			key: \lever,
			shared: ('hidUsagePage': 1, 'elementType': 'lever', 'spec': \unipolar),
			elements: [
				(key: \left,  'hidUsage': 50),
				(key: \right,  'hidUsage': 54)
			]
		)
	]
);
)
