
/*
desc file for Thrustmater ferrari gamepad.

two details:
 bt 11 and 12 are actually joy_l_hat and joy_r_hat,
so moved them there.

in \compass, id 57, the reported range is wrong:
instead of [0, 7], it it is [0, 15] when including
the value 15, which is sent when compass but is released.
the directions are:

     0
  7      1
6    15    2
  5      3
     4

// example for fixing this and using compass directions:

HIDMKtl.find;
f = HIDMKtl('rnnd0');
f.printElementNames;

c = f.elementsDict[\compass];
c.action = { |el|
// calc integer value for indexing:
var intVal = (el.value * 15).round.asInteger;
var dir;
[el.value, intVal, el.rawValue].round(0.001).postln;
if (intVal == 15) {
"rnd compass released.".postln
} {
dir = [\N, \NE, \E, \SE, \S, \SW, \W, \NW][intVal];
"rnd compass direction: %\n".postf(dir);
};
};

// test that joy hat works:
f.elementsDict[\joy_l_hat].action = { |el| [el.name, el.value].postln };
f.elementAt(\joy, \r, \hat).action = { |el| [el.name, el.value].postln };

*/

(
deviceName: "Run'N' Drive_Thrustmaster",
protocol: \hid,
deviceType: \gamepad,
elementTypes: [\joystick, \button, \wheel, \throttle, \compass, \rumble],
status: (
	linux: "unknown",
	osx: "tested and working",
	win: "unknown"),

idInfo: "Run'N' Drive_Thrustmaster",

deviceInfo: (
	vendorURI: "http://www.thrustmaster.com/products/runndrive-wireless-3-in1-rumble-force",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",
	// type: [],
	// hasScribble: false
),
specs: (\compassRND: [0, 8, \lin, 1, 1].asSpec),
description: [
	'bt' -> [
		// --------- input elements ----------
		'1' -> ('hidUsage': 1, 'style': (row: 1.8, column: 4.4, showLabel: true)),
		'2' -> ('hidUsage': 2, 'style': (row: 2.6, column: 5.2, showLabel: true)),
		'3' -> ('hidUsage': 3, 'style': (row: 1.8, column: 6.0, showLabel: true)),
		'4' -> ('hidUsage': 4, 'style': (row: 1.0, column: 5.2, showLabel: true)),
		// shoulders
		'5' -> ('hidUsage': 5, 'style': (row: 0, column: 1, showLabel: true)),
		'6' -> ('hidUsage': 6, 'style': (row: 0, column: 5, showLabel: true)),
		// underside
		'7' -> ('hidUsage': 7, 'style': (row: 0, column: 2.5, showLabel: true)),
		'8' -> ('hidUsage': 8, 'style': (row: 0, column: 3.5, showLabel: true)),
		'9' -> ('hidUsage': 9, 'style': (row: 1.6, column: 2.5, showLabel: true)),
		'10'-> ('hidUsage': 10,'style': (row: 1.6, column: 3.5, showLabel: true))
	].collect { |assoc|
		assoc.value.putAll(('hidUsagePage': 9, 'elementType': 'button', 'ioType': 'in', spec: \hidBut, mode: \push))
	},

	'compass' -> ('hidUsage': 57, 'hidUsagePage': 1, 'elementType': 'compass',
		'ioType': 'in', spec: \compassRND, mode: \center,
		'style': (row: 1.8, column: 1.3, showLabel: true)
	),

	'joy' -> [
		\l -> [
			\x -> ('hidUsage': 48, 'hidUsagePage': 1, 'elementType': 'joyAxis', 'ioType': 'in', spec: \cent1, mode: \center,
				'style': (row: 4, column: 1, showLabel: true)
			),
			\y -> ('hidUsage': 49, 'hidUsagePage': 1, 'elementType': 'joyAxis',
				'ioType': 'in', spec: \cent1, mode: \center,
				'style': (row: 4, column: 2, showLabel: true)
			),
			\hat -> ('hidUsage': 11, 'hidUsagePage': 9, 'elementType': 'button',
				'ioType': 'in', spec: \hidBut, mode: \push,
				'style': (row: 3.2, column: 1.5, showLabel: true)
			)
		],
		\r -> [
			\x -> ('hidUsage': 50, 'hidUsagePage': 1, 'elementType': 'joyAxis',
				'ioType': 'in', spec: \cent1, mode: \center,
				'style': (row: 4, column: 3, showLabel: true)
			),
			\y -> ('hidUsage': 53, 'hidUsagePage': 1, 'elementType': 'joyAxis',
				'ioType': 'in', spec: \cent1, mode: 'center',
				'style': (row: 4, column: 4, showLabel: true)
			),
			\hat -> ('hidUsage': 12, 'hidUsagePage': 9, 'elementType': 'button',
				'ioType': 'in', spec: \hidBut, mode: \push,
				'style': (row: 3.2, column: 3.5, showLabel: true)
			)
		]
	],

	'throt' -> [
		\l -> ('hidUsage': 51, 'hidUsagePage': 1, 'elementType': 'springFader',
			'ioType': 'in', mode: \minimum, spec: \lin1inv,
			'style': (row: 0, column: 0, showLabel: true)
		),
		\r -> ('hidUsage': 52, 'hidUsagePage': 1, 'elementType': 'springFader',
			'ioType': 'in', mode: \minimum, spec: \lin1inv,
			'style': (row: 0, column: 6, showLabel: true)
		)
	],
	'wheel' -> ('hidUsage': 54, 'hidUsagePage': 1, 'elementType': 'springFader',
		'ioType': 'in', spec: \cent1inv, mode: \center,
		'style': (row: 1, column: 0, showLabel: true)
	),

	// --------- output elements ----------
	'rumble' -> [
		\l -> ('hidUsage': 187, 'hidUsagePage': 1, 'elementType': 'rumble', 'ioType': 'out', spec: \lin255, mode: \minimum,
			'style': (row: 4, column: 1, showLabel: true)
		),
		// this one is different in OSX due to a bug in the Apple API, but does not work yet anyways
		\r -> ('hidUsage': 0, 'hidUsagePage': 1, 'elementType': 'rumble', 'ioType': 'out', spec: \lin255, mode: \minimum,
			'style': (row: 4, column: 1, showLabel: true)
		)
	]
]
);
