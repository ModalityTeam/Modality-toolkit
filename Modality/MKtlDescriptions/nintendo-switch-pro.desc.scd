/****
ToDo
- update when/if
CompassView and StickView classes are integrated.

MKtl(\swpro).free;
m = MKtl(\swpro, "*switch-pro");
m.gui;

// conversion from arrows to 8 directions + up/release
m.elAt(\arrows).action = { |el|
    var intVal = (el.deviceValue * 7 + 1).round.asInteger;
    var dirs = [\rest, \N, \NE, \E, \SE, \S, \SW, \W, \NW, \up];
	[\arrows, intVal, dirs.clipAt(intVal), el.value.asFraction].postcs;
};

***/
(
idInfo: "Pro Controller_Unknown",

protocol: 'hid',
deviceName: "Nintendo Pro Controller",
deviceType: 'joystick',
elementTypes: [\joystick, \button],
status: (
	linux: "unknown",
	osx: "Seems to Work - Sam Pluta 05/13/20",
	win: "unknown"
),

deviceInfo: (
	vendorURI: "https://www.nintendo.com/",
	manualURI: "",
	longName: "Nintendo Switch Pro",
	// description: "",
	// features: [],
	// notes: "",

	hasScribble: false
),

elementsDesc: (
	elements: [
		(
			key: \bt,
			shared: ('hidUsagePage': 9, 'elementType': 'button',
				'ioType': 'in', 'spec': \hidBut ),
			elements: [
				(key: '1', 'hidUsage': 1, 'style': (row: 2.5, column: 4)),
				(key: '2', 'hidUsage': 2, 'style': (row: 2, column: 4.8)),
				(key: '3', 'hidUsage': 3, 'style': (row: 2, column: 3.2)),
				(key: '4', 'hidUsage': 4, 'style': (row: 1.5, column: 4)),
				(key: '5', 'hidUsage': 5, 'style': (row: 1, column: 0)),
				(key: '6', 'hidUsage': 6, 'style': (row: 1, column: 6)),
				(key: '7', 'hidUsage': 7, 'style': (row: 0, column: 0)),
				(key: '8', 'hidUsage': 8, 'style': (row: 0, column: 6)),
				(key: '9', 'hidUsage': 9, 'style': (row: 0, column: 2)),
				(key: '10', 'hidUsage': 10, 'style': (row: 0, column: 2.8)),
				(key: '11', 'hidUsage': 11, 'style': (row: 3.2, column: 1.2)),
				(key: '12', 'hidUsage': 12, 'style': (row: 3.2, column: 5.2)),
				(key: '13', 'hidUsage': 13, 'style': (row: 0.8, column: 2.8)),
				(key: '14', 'hidUsage': 14, 'style': (row: 0.8, column: 2))
			],
		),
		(
			key: \joy,
			shared: ('hidUsagePage': 1, 'elementType': 'joyAxis', 'ioType': 'in', 'spec': \cent1),
			elements: [
				(key: \x1, 'hidUsage': 48, 'style': (row: 4, column: 0.2, height: 1, width: 2)),
				(key: \y1, 'hidUsage': 49, spec:[1.0,0.0], 'style': (row: 3, column: 2, height: 2, width: 1)),
				(key: \x2, 'hidUsage': 51, 'style': (row: 4, column: 4.2, height: 1, width: 2)),
				(key: \y2, 'hidUsage': 52, spec:[1.0,0.0], 'style': (row: 3, column: 6, height: 2, width: 1))
			]
		),
		(key: \arrows,
			elements: [(hidUsage: 57, 'hidUsagePage': 1, spec:[0.0,8/7,\lin,1/7], 'ioType': 'in', 'elementType': 'slider', 'style': (row: 5, column: 2.5, height: 1, width: 2))]
		)
	]
)
)