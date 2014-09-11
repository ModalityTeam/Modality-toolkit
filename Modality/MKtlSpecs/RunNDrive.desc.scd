(
device: "Run'N' Drive_Thrustmaster",
protocol: \hid,
description: (
	// --------- input elements ----------
	'b1': ('hidUsage': 1, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
	'b2': ('hidUsage': 2, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
	'b3': ('hidUsage': 3, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
	'b4': ('hidUsage': 4, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
	'b5': ('hidUsage': 5, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
	'b6': ('hidUsage': 6, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
	'b7': ('hidUsage': 7, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
	'b8': ('hidUsage': 8, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
	'b9': ('hidUsage': 9, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
	'b10': ('hidUsage': 10, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
	'b11': ('hidUsage': 11, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),
	'b12': ('hidUsage': 12, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', spec: \hidBut, mode: \push ),

	'hat': ('hidUsage': 57, 'hidUsagePage': 1, 'type': 'hatSwitch', 'ioType': 'in', spec: \cent1, mode: \center),

	'joy': (
		\l:(
			\x: ('hidUsage': 48, 'hidUsagePage': 1, 'type': 'joyAxis', 'ioType': 'in', spec: \cent1, mode: \center ),
			\y: ('hidUsage': 49, 'hidUsagePage': 1, 'type': 'joyAxis', 'ioType': 'in', spec: \cent1, mode: \center )
		),
		\r:(
			\x: ('hidUsage': 50, 'hidUsagePage': 1, 'type': 'joyAxis', 'ioType': 'in', spec: \cent1, mode: \center ),
			\y: ('hidUsage': 53, 'hidUsagePage': 1, 'type': 'joyAxis', 'ioType': 'in', spec: \cent1, mode: 'center' )
		)
	),

	'throt': (
		\l: ('hidUsage': 51, 'hidUsagePage': 1, 'type': 'springFader', 'ioType': 'in', mode: \minimum, spec: \lin1inv ),
		\r: ('hidUsage': 52, 'hidUsagePage': 1, 'type': 'springFader', 'ioType': 'in', mode: \minimum, spec: \lin1inv )
	),
	'wheel': ('hidUsage': 54, 'hidUsagePage': 1, 'type': 'springFader', 'ioType': 'in', spec: \cent1inv, mode: \center ),

	// --------- output elements ----------
	'rumble':(
		\l: ('hidUsage': 187, 'hidUsagePage': 1, 'type': 'rumble', 'ioType': 'out', spec: \lin255, mode: \minimum ),
		\r: ('hidUsage': 0, 'hidUsagePage': 1, 'type': 'rumble', 'ioType': 'out', spec: \lin255, mode: \minimum ) // this one is different in OSX due to a bug in the Apple API, but does not work yet anyways
	)
)
)