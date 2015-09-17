(
deviceName: "USB Optical Mouse_",
protocol: 'hid',
deviceType: \mouse,
elementTypes: [\button, \mouseAxis, \mouseWheel],
status: "unknown",

idInfo: "USB Optical Mouse_",

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	// description: "Interface to a generic optical mouse",
	features: [
		"3 buttons",
		"scroll wheel"
	],
	// notes: "",

	// hasScribble: false
),
description: (
// --------- input elements ----------
	bt: (
		'left': ('hidUsage': 1, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', \spec: \hidBut),
		'right': ('hidUsage': 2, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', \spec: \hidBut),
		'middle': ('hidUsage': 3, 'hidUsagePage': 9, 'type': 'button', 'ioType': 'in', \spec: \hidBut)
	),
	x: ('hidUsage': 48, 'hidUsagePage': 1, 'type': 'mouseAxis', 'ioType': 'in', \spec: \mouseAxis, valueType: \relative ),
	y: ('hidUsage': 49, 'hidUsagePage': 1, 'type': 'mouseAxis', 'ioType': 'in', \spec: \mouseAxis, valueType: \relative ),
	wheel: ('hidUsage': 56, 'hidUsagePage': 1, 'type': 'mouseWheel', 'ioType': 'in', \spec: \mouseWheel, valueType: \relative ),
)
);