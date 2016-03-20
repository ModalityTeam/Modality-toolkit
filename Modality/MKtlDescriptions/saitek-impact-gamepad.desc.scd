/*
Known problems:
* compass is dodgy - on the HID side already?
- see little conversion example

ToDO:
* check output elements - LEDs?
* include rumble outputs in elements, test

* make little example.

// test this desc:
~thisdesc = thisProcess.nowExecutingPath.basename.split($.).first.postcs;
d = MKtlDesc.loadDescs(~thisdesc).first;

// close old m, open new one, make gui:
m.free; m = MKtl(\gp, "*impact-gamepad"); m.gui;

m.trace;
m.elementsDict.size;
m.postElements;

// compass has 8 directions + rest value:
m.elAt(\compass).action = { |el|
	var intVal = (el.deviceValue * 7 + 1).round.asInteger;
	var dirs = [\rest, \N, \NE, \E, \SE, \S, \SW, \W, \NW];
	[\compass, intVal, dirs[intVal]].postln;
};


*/

MKtl.addSpec(\compassImpact, [0, 1.0]);

(
deviceName: "USB Game Controllers_Mega World",
protocol: 'hid',
deviceType: \gamepad,
elementTypes: [\joystick, \button, \compass],
status: (
	linux: "not working. backend issue in hid. 2016-03-20, nescivi",
	osx: "tested and working. 2015-03-16, adc",
	win: "unknown"),

idInfo: "USB Game Controllers_Mega World",

// specs: (compassImpact: [-1, 6, \lin, 1].asSpec),

deviceInfo: (
	// vendorURI: "http://",
	// manualURI: "http://",
	// description: "",
	// features: [
	// ],
	longName: "Saitek Cyborg Mega World"
),
elementsDesc: (
	elements: [
		(
			key: \bt,
			shared: ('hidUsagePage': 9, 'elementType': 'button', 'ioType': 'in',spec: \hidBut ),
			elements: [
				// right side buttons
				(key: '1', 'hidUsage': 1,
					'style': (row: 1.8, column: 4.4, height: 0.5, showLabel: true)),
				(key: '2', 'hidUsage': 2,
					'style': (row: 1.0, column: 5.2, height: 0.5, showLabel: true)),
				(key: '3', 'hidUsage': 3,
					'style': (row: 2.6, column: 5.2, height: 0.5, showLabel: true)),
				(key: '4', 'hidUsage': 4,
					'style': (row: 1.8, column: 6.0, height: 0.5, showLabel: true)),

				// shoulders
				(key: '5', 'hidUsage': 5,
					'style': (row: 0.5, column: 1, height: 0.5, showLabel: true)),
				(key: '6', 'hidUsage': 6,
					'style': (row: 0.0, column: 1, height: 0.5, showLabel: true)),
				// underside
				(key: '7', 'hidUsage': 7,
					'style': (row: 0.5, column: 5, height: 0.5, showLabel: true)),
				(key: '8', 'hidUsage': 8,
					'style': (row: 0.0, column: 5, height: 0.5, showLabel: true)),
				// top center
				(key: '9', 'hidUsage': 9,
					'style': (row: 1.6, column: 2.5, height: 0.5, showLabel: true)),
				(key: '10', 'hidUsage': 10,
					'style': (row: 1.6, column: 3.5, height: 0.5, showLabel: true)),
			]
		),
		(
			key: 'compass', 'hidUsage': 57, 'hidUsagePage': 1,
			'elementType': 'compass', 'ioType': 'in', spec: \compassImpact,
			'style': (row: 1.8, column: 1.3, showLabel: true)
		),
		(
			key: \joy,
			shared: ('hidUsagePage': 1, 'elementType': 'joyAxis', 'ioType': 'in',
				spec: \cent1, mode: \center ),
			elements: [
				(
					key: \l,
					elements: [
						(key: \x, 'hidUsage': 48, 'elementType': 'joyAxis', spec: \cent1,
							mode: \center, 'style': (row: 3.5, column: 1, height: 2, showLabel: true)
						),
						(key: \y, 'hidUsage': 49, 'elementType': 'joyAxis', spec: \cent1,
							mode: \center, 'style': (row: 3.5, column: 1.9, height: 2, showLabel: true)
						),
						(key: \hat, 'hidUsage': 11, 'elementType': 'button', 'hidUsagePage': 9,
							spec: \hidBut, mode: \push,
							'style': (row: 3.2, column: 1.5, height: 0.5, showLabel: true)
						)
					]
				),
				(
					key: \r,
					elements: [
						(key: \x, 'hidUsage': 53, 'elementType': 'joyAxis', spec: \cent1,
							mode: \center, 'style': (row: 3.5, column: 3, height: 2, showLabel: true)
						),
						(key: \y, 'hidUsage': 50, 'elementType': 'joyAxis', spec: \cent1,
							mode: 'center', 'style': (row: 3.5, column: 3.9, height: 2, showLabel: true)
						),
						(key: \hat, 'hidUsage': 12, 'hidUsagePage': 9, 'elementType': 'button',
							spec: \hidBut, mode: \push,
							'style': (row: 3.2, column: 3.5, height: 0.5, showLabel: true)
						)
					]
				)
			]
		),
	]

// --------- output elements ----------
	// '<element name undefined>': ('hidUsage': 67, 'hidUsagePage': 8, 'elementType': '<type Led>', 'ioType': 'out' ),
	// '<element name undefined>': ('hidUsage': 68, 'hidUsagePage': 8, 'type': '<type Led>', 'ioType': 'out' ),
	// '<element name undefined>': ('hidUsage': 69, 'hidUsagePage': 8, 'type': '<type Led>', 'ioType': 'out' ),
	// '<element name undefined>': ('hidUsage': 70, 'hidUsagePage': 8, 'type': '<type Led>', 'ioType': 'out' ),
)
);