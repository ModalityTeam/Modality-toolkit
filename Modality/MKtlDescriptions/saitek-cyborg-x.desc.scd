/*
compass on Saitek Joystick has these deviceValues
15: center
1: up
3: right
5: down
7: left.

how to map that in a spec? see saitek-impact-gamepad.desc

MKtlDesc.loadDescs;
MKtl(\cybx).free;
MKtl(\cybx, "*cyborg-x").gui;
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
			'hidUsage': 1, 'hidUsagePage': 9, 'elementType': 'trigger', 'spec': \hidBut,
			'style': (row: 3, column: 4, showLabel: true)
		),
		(
			key: \bt,
			shared: ('hidUsagePage': 9, 'elementType': 'button', 'spec': \hidBut ),
			elements: [
				// buttons on joyHead
				(key: '2', 'hidUsage': 2, style: (row: 1, column: 3, showLabel: true)),
				(key: '3', 'hidUsage': 3, style: (row: 1, column: 5, showLabel: true)),
				(key: '4', 'hidUsage': 4, style: (row: 0, column: 3, showLabel: true)),
				(key: '5', 'hidUsage': 5, style: (row: 0, column: 5, showLabel: true)),

				// on base left
				(key: '6', 'hidUsage': 6, style: (row: 2.5, column: 2, showLabel: true)),
				(key: '7', 'hidUsage': 7, style: (row: 3.5, column: 2, showLabel: true)),
				(key: '8', 'hidUsage': 8, style: (row: 4.5, column: 2, showLabel: true)),
				(key: '9', 'hidUsage': 9, style: (row: 5.5, column: 2, showLabel: true)),

				// on left foot
				(key: '10', 'hidUsage': 10, style: (row: 6, column: 0, showLabel: true)),
				(key: '11', 'hidUsage': 11, style: (row: 6, column: 1, showLabel: true)),
				// on base, center
				(key: '14', 'hidUsage': 14, style: (row: 6, column: 4, showLabel: true))
			],
		),
		(
			key: \scroll,
			shared: ('hidUsagePage': 9, 'elementType': 'scrollWheel', 'spec': \hidBut),
			elements: [
				(	key: \up, 'hidUsage': 12, style: (row: 2, column: 3.5, showLabel: true)),
				(	key: \down, 'hidUsage': 13, style: (row: 2, column: 4.5, showLabel: true)),
			]
		),
		(
			key: \joy,
			shared: ('hidUsagePage': 1, 'elementType': 'joyAxis', 'spec': \cent1),
			elements: [
				(key: \x, 'hidUsage': 48, style: (row: 4, column: 3, height: 2, showLabel: true)),
				(key: \y, 'hidUsage': 49, style: (row: 4, column: 4, height: 2, showLabel: true)),
				(key: \rot, 'hidUsage': 53, style: (row: 4, column: 5, height: 2, showLabel: true))
			]
		),
		(
			key: \compass, 'hidUsage': 57, 'hidUsagePage': 1, 'elementType': 'compass',
			spec: \unipolar,
			style: (row: 0.5, column: 4, showLabel: true)
		),
		(
			key: \lever,
			shared: ('hidUsagePage': 1, 'elementType': 'lever', 'spec': \unipolar),
			elements: [
				(key: \left,  'hidUsage': 50, style: (row: 4, column: 0, height: 2, showLabel: true)),
				(key: \right,  'hidUsage': 54, style: (row: 4, column: 1, height: 2, showLabel: true))
			]
		)
	]
);
)
