(
idInfo: "Generic Mouse",
protocol: 'hid',
deviceType: \mouse,
elementTypes: [\mouseAxis, \button, \mouseWheel],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

deviceName: "Generic Mouse",

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	description: "Interface to a generic mouse",
	features: [
		"3 buttons",
		"scroll wheel",
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
	x: ('hidUsage': 48, 'hidUsagePage': 1, 'type': 'mouseAxis', 'ioType': 'in', \spec: \mouseAxis, valueType: \relative),
	y: ('hidUsage': 49, 'hidUsagePage': 1, 'type': 'mouseAxis', 'ioType': 'in', \spec: \mouseAxis ),
	wheel: ('hidUsage': 56, 'hidUsagePage': 1, 'type': 'mouseWheel', 'ioType': 'in', \spec: \mouseAxis, valueType: \relative ),
)
);