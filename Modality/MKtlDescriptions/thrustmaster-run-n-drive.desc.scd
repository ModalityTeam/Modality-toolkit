
/*
desc file for Thrustmater ferrari gamepad.

Notes:

* rumble is only on a single motor, no left and right ( see test below)

* \compass, id 57, reports a wrong range to HID:
  instead of [0, 7], it is actually [0, 15] when including the value 15,
  which is sent when compass but is released.

The directions are (el.deviceValue * 7):

//     0
//   7    1
// 6   15   2
//   5    3
//     4

// find gp and trace it:
MKtlDesc.loadDescs;
MKtl.find(\hid);
f = MKtl('f', "thrustmaster-run-n-drive");
f.gui;
f.postElements;
f.trace;

// example for fixing this and using compass directions:
f.dictAt(\compass).action = { |el|
	// calc integer value for indexing:
	var intVal = (el.deviceValue * 7).round.asInteger;
	var dir;
	[el.value, intVal, el.deviceValue].round(0.001).postln;
	if (intVal == 15) {
		"rnd compass released.".postln
	} {
		dir = [\N, \NE, \E, \SE, \S, \SW, \W, \NW][intVal];
		"rnd compass direction: %\n".postf(dir);
	};
};

// test that joy hat accessing works:
f.trace(false);
f.elAt(\joy, \l, \hat);
f.dictAt(\joy_l_hat);
f.elAt(\joy, 0, 2); // left is index 0, hat is index 2


f.dictAt(\joy_l_hat).action = { |el| [el.name, el.value].postln };
f.elementAt(\joy, \r, \hat).action = { |el| [el.name, el.value].postln };


// test for rumble outputs
f.elAt( \rumble, \l ).value_(1);
f.elAt( \rumble, \l ).value_(0.5);
f.elAt( \rumble, \l ).value_(0);

f.elAt( \rumble, \r ).value_(1);
f.elAt( \rumble, \r ).value_(0.5);
f.elAt( \rumble, \r ).value_(0);

// - both rumble outs address the same motor,
// - seems that hidUSage 187 is irrelevant - arbitrary change to 123 does the same thing.


*/

(
deviceName: "Run'N' Drive_Thrustmaster",
protocol: \hid,
deviceType: \gamepad,
elementTypes: [\joystick, \button, \wheel, \throttle, \compass, \rumble],
status: (
	linux: "unknown",
	osx: "tested and working. 2016-03-16, adc",
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

elementsDesc: (
	elements: [

		// --------- input elements ----------
		(
			key: 'bt',
			shared: ('hidUsagePage': 9, 'elementType': 'button',
				'ioType': 'in', spec: \hidBut, mode: \push),

			elements: [
				(key: '1', 'hidUsage': 1, 'style': (row: 1.8, column: 4.4)),
				(key: '2', 'hidUsage': 2, 'style': (row: 2.6, column: 5.2)),
				(key: '3', 'hidUsage': 3, 'style': (row: 1.8, column: 6.0)),
				(key: '4', 'hidUsage': 4, 'style': (row: 1.0, column: 5.2)),
				// shoulders
				(key: '5', 'hidUsage': 5, 'style': (row: 0, column: 1)),
				(key: '6', 'hidUsage': 6, 'style': (row: 0, column: 5)),
				// underside
				(key: '7', 'hidUsage': 7, 'style': (row: 0, column: 2.5)),
				(key: '8', 'hidUsage': 8, 'style': (row: 0, column: 3.5)),
				// top center
				(key: '9', 'hidUsage': 9, 'style': (row: 1.6, column: 2.5)),
				(key: '10', 'hidUsage': 10,'style': (row: 1.6, column: 3.5))
			]
		),

		(
			key: 'compass', 'hidUsage': 57, 'hidUsagePage': 1, 'elementType': 'compass',
			'ioType': 'in', mode: \center, spec: \unipolar,
			'style': (row: 1.8, column: 1.3)
		),

		(
			key: 'joy',
			shared: ('hidUsagePage': 1, 'ioType': 'in'),
			elements: [
				(
					key: \l,
					elements: [
						(key: \x, 'hidUsage': 48, 'elementType': 'joyAxis', spec: \cent1,
							mode: \center, 'style': (row: 4, column: 1)
						),
						(key: \y, 'hidUsage': 49, 'elementType': 'joyAxis', spec: \cent1,
							mode: \center, 'style': (row: 4, column: 2)
						),
						(key: \hat, 'hidUsage': 11, 'elementType': 'button', 'hidUsagePage': 9,
							spec: \hidBut, mode: \push,
							'style': (row: 3.2, column: 1.5)
						)
					]
				),
				(
					key: \r,
					elements: [
						(key: \x, 'hidUsage': 50, 'elementType': 'joyAxis', spec: \cent1,
							mode: \center, 'style': (row: 4, column: 3)
						),
						(key: \y, 'hidUsage': 53, 'elementType': 'joyAxis', spec: \cent1,
							mode: 'center', 'style': (row: 4, column: 4)
						),
						(key: \hat, 'hidUsage': 12, 'hidUsagePage': 9, 'elementType': 'button',
							spec: \hidBut, mode: \push,
							'style': (row: 3.2, column: 3.5)
						)
					]
				)
			]
		),
		(
			key: 'throt',
			shared: ('hidUsagePage': 1, 'elementType': 'springFader',
				'ioType': 'in', mode: \minimum, spec: \lin1inv),
			elements: [
				(key: \l, 'hidUsage': 51, 'style': (row: 0, column: 0)),
				(key: \r, 'hidUsage': 52, 'style': (row: 0, column: 6))
			]
		),
		(
			key: 'wheel', 'hidUsage': 54, 'hidUsagePage': 1, 'elementType': 'springFader',
			'ioType': 'in', spec: \cent1inv, mode: \center,
			'style': (row: 1, column: 0)
		),

		// --------- output elements ----------

		(
			key: 'rumble',
			shared: ('elementType': 'rumble', 'ioType': 'out',
				spec: \lin255, mode: \minimum),
			elements: [
				(
					key: \l,
					'hidUsage': 187, 'hidUsagePage': 1, hidElementID: 32,
					'style': (row: 4, column: 0)
				),
				(
					key: \r,
					'hidUsage': 123, 'hidUsagePage': 1, hidElementID: 32,
					'style': (row: 4, column: 5)
				)
			]
		)
	]
);
)