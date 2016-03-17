/*

// HID reports all buttons and joystick as in and out elements,
// but sending to them does nothing ... keeping them anyway

MKtl.find;
m = MKtl('cc', "saitek-cyborg-command-pad-unit");
m.trace;
m.trace(false)
x.free
m.elementsDict.do { |el| el.valueAction_(0) };

// HID reports all buttons and joystick as in and out elements,
// but sending to them does nothing ... keeping them anyway

m.elAt(\bt).do(_.valueAction_(0));
m.elAt(\bt).do(_.valueAction_(1));

*/

(
idInfo: "Saitek Cyborg Command Pad Unit_",
status: (
	linux: "unknown",
	osx: "tested and working. 2016-03-17, adc",
	win: "unknown"
),

protocol: 'hid',

// specs: (uni1023: [1, 1023, \lin, 1/1023]),

elementsDesc: (
	elements: [
		(
			// numKeys:
			key: \bt,
			shared: ( key: '_b1_', 'hidUsage': 1, 'hidUsagePage': 9, 'elementType': 'Button', 'ioType': 'inout', 'spec': 'hidBut' ),
			elements: ((1..16) ++ 21).collect { |num|
				( key: num.asSymbol, hidUsage: num)
			},
		),
		(
			// mode switch sends on top: 24 on, prev (23 or 22) off
			// middle is 23 on, prev (22 or 24) off
			// bottom is 22 on, 23 off [22, 1], [
			key: \mode,
			shared: ( key: '_b1_', 'hidUsage': 1, 'hidUsagePage': 9, 'elementType': 'Button', 'ioType': 'inout', 'spec': 'hidBut' ),
			elements: [22, 23, 24].collect { |num, i|
				( key: num.asSymbol, hidUsage: num)
			}
		),
		(
			// F1 .. F4 buttons
			key: \F,
			shared: ( key: '_b1_', 'hidUsage': 1, 'hidUsagePage': 9, 'elementType': 'Button', 'ioType': 'inout', 'spec': 'hidBut' ),
			elements: [17, 18, 19, 20].collect { |num, i|
				( key: (i+1).asSymbol, hidUsage: num)
			}
		),
		(
			key: \joy,
			shared: ( 'hidUsagePage': 1, 'elementType': 'thumbAxis', 'ioType': 'inout',
				\spec: \unipolar
			),
			elements: [
				(key: 'x', 'hidUsage': 48),
				(key: 'y', 'hidUsage': 49)
			]
		)
	]
	)
);
