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
deviceType: \joyStick,
idInfo: "Cyborg X_Saitek",
protocol: 'hid',
status: (
	linux: "unknown",
	osx: "tested and working",
	win: "unknown"),


deviceInfo: (

),

specs: (compass: [0, 15, \lin, 1]),

elementsDesc: (
	elements: [
		(
			key: \trig,
			'hidUsage': 1, 'hidUsagePage': 9, 'elementType': 'trigger', 'ioType': 'in', 'spec': \hidBut
		),
		(
			key: \bt,
			sharedProperties: ('hidUsagePage': 9, 'elementType': 'button',
				'ioType': 'in', 'spec': \hidBut ),
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
			sharedProperties: ('hidUsagePage': 9, 'elementType': 'button', 'ioType': 'in', 'spec': \hidBut),
			elements: [
				(	key: \up, 'hidUsage': 12),
				(	key: \down, 'hidUsage': 13),
			]
		),
		(
			key: \joy,
			sharedProperties: ('hidUsagePage': 1, 'elementType': 'joyAxis', 'ioType': 'in', 'spec': \cent1),
			elements: [
				(key: \x, 'hidUsage': 48),
				(key: \y, 'hidUsage': 49),
				(key: \z, 'hidUsage': 53)
			]
		),
		(
			key: \compass,
			'hidUsage': 57, 'hidUsagePage': 1, 'elementType': 'joyAxis', 'ioType': 'in', 'spec': \compass),
		(
			key: \lever,
			sharedProperties: ('hidUsagePage': 1, 'elementType': 'lever', 'ioType': 'in', 'spec': \unipolar),
			elements: [
				(key: \left,  'hidUsage': 50),
				(key: \right,  'hidUsage': 54)
			]
		)
	]
);
)
