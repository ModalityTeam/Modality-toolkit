/*
compass on Saitek Joystick has:
15: center
1: up
3: right
5: down
7: left.

how to map that in a spec?

*/
(
deviceName: "Cyborg X_Saitek",
idInfo: "Cyborg X_Saitek",
protocol: 'hid',

deviceInfo: (

),

specs: (compass: [0, 15, \lin, 1]),

description: (


	// --------- input elements ----------
	bt: (
		// gunTrigger
		'1': ('hidUsage': 1, 'hidUsagePage': 9, 'type': 'trigger', 'ioType': 'in', 'spec': \hidBut ),
		// buttons on joyHead
		'2': ('hidUsage': 2, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', 'spec': \hidBut ),
		'3': ('hidUsage': 3, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', 'spec': \hidBut ),
		'4': ('hidUsage': 4, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', 'spec': \hidBut ),
		'5': ('hidUsage': 5, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', 'spec': \hidBut ),
		// on base left
		'6': ('hidUsage': 6, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', 'spec': \hidBut ),
		'7': ('hidUsage': 7, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', 'spec': \hidBut ),
		'8': ('hidUsage': 8, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', 'spec': \hidBut ),
		'9': ('hidUsage': 9, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', 'spec': \hidBut ),
		// on left foot
		'10': ('hidUsage': 10, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', 'spec': \hidBut ),
		'11': ('hidUsage': 11, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', 'spec': \hidBut ),

		// on base, center
		'14': ('hidUsage': 14, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', 'spec': \hidBut),

	),
	joy: (
		x: ('hidUsage': 48, 'hidUsagePage': 1, 'type': 'joyAxis', 'ioType': 'in', 'spec': \cent1023),
		y: ('hidUsage': 49, 'hidUsagePage': 1, 'type': 'joyAxis', 'ioType': 'in', 'spec': \cent1023),
		z: ('hidUsage': 53, 'hidUsagePage': 1, 'type': 'joyAxis', 'ioType': 'in', 'spec': \cent255)
	),

	compass:  ('hidUsage': 53, 'hidUsagePage': 1, 'type': 'joyAxis', 'ioType': 'in', 'spec': \compass),

	'lever': (
		left:  ('hidUsage': 50, 'hidUsagePage': 1, 'type': 'lever', 'ioType': 'in', 'spec': \lin255),
		right: ('hidUsage': 54, 'hidUsagePage': 1, 'type': 'lever', 'ioType': 'in', 'spec': \lin255),
	)
);
)
