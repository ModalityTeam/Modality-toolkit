(
deviceName: "USB Optical Mouse_",
protocol: 'hid',
deviceType: \mouse,
elementTypes: [\button, \mouseAxis, \mouseWheel],
status: (
	linux: "unknown",
	osx: "tested and working. 2016-03-24, adc",
	win: "unknown"),

idInfo: "USB Optical Mouse_",

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	// description: "Interface to a generic optical mouse",
	features: [
		"3 buttons",
		"scroll wheel"
	],
	longName: "Generic Optical Mouse",
	notes: "See also [Generic Mouse](generic-mouse.html)"

),
elementsDesc: (
// --------- input elements ----------
	elements: [
		(
			key: \bt,
			shared: (hidUsagePage: 9, elementType: \button, ioType: 'in', spec: \hidBut),
			elements: [
				(key: \left, hidUsage: 1),
				(key: \right,  hidUsage: 2),
				(key: \middle,  hidUsage: 3)
			]
		),
		(
			key: \x,
			hidUsage: 48, hidUsagePage: 1, elementType: \mouseAxis,
			ioType: 'in', spec: \mouseAxis, valueType: \relative
		),
		(
			key: \y,
			hidUsage: 49, hidUsagePage: 1, elementType: \mouseAxis,
			ioType: 'in', spec: \mouseAxis, valueType: \relative
		),
		(
			key: \wheel,
			hidUsage: 56, hidUsagePage: 1, elementType: \mouseWheel,
			ioType: 'in', spec: \mouseAxis, valueType: \relative
		)
	]
)
);