(
idInfo: "Generic Mouse",
protocol: 'hid',
deviceType: \mouse,
elementTypes: [\mouseAxis, \button, \mouseWheel],
status: (
	linux: "unknown",
	osx: "tested and working. 2016-03-24, adc",
	win: "unknown"),

deviceName: "Generic Mouse",

deviceInfo: (
	vendorURI: "too many to list",
	// manualURI: "",
	features: [
		"2 mouse axes",
		"3 buttons",
		"scroll wheel",
	],
	longName: "Generic Mouse",
	notes: "",
	// hasScribble: false
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