/*

// HID reports all buttons and joystick as in and out elements,
// but sending to them does nothing ... keeping them anyway

MKtlDesc.loadDescs("saitek-cyborg-command-pad-unit");
m.free; m = MKtl('cc', "saitek-cyborg-command-pad-unit").gui;

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
deviceType: \gamepad,
protocol: 'hid',
deviceInfo: (
	// vendorURI: "http://",
	// manualURI: "http://",
	// description: "",
	// features: [
	// ],
	longName: "Saitek Cyborg Command Pad"
),

// specs: (uni1023: [1, 1023, \lin, 1/1023]),

elementsDesc: (
	elements: [
		(
			// numKeys:
			key: \bt,
			shared: ( key: '_b1_', 'hidUsage': 1, 'hidUsagePage': 9, 'elementType': 'button', 'ioType': 'inout', 'spec': 'hidBut' ),

			// name, row, column,
			elements: [
				[1, 1, 1],
				[2, 1, 2],
				[3, 1, 3],
				[4, 1, 4],

				[5, 2, 1.3],
				[6, 2, 2.3],
				[7, 2, 3.3],
				[8, 2, 4.3],

				[9,  3, 1.6],
				[10, 3, 2.6],
				[11, 3, 3.6],

				[12, 2, 0],
				[13, 3, 0],
				[14, 4, 0],

				[15, 5, 5],
				[16, 4, 5],
				[21, 5, 4]
			].collect { |nums|
				( key: nums[0].asSymbol, hidUsage: nums[0],
					style: (row: nums[1], column: nums[2])
				)
			},
		),
		(
			// mode switch sends on top: 24 on, prev (23 or 22) off
			// middle is 23 on, prev (22 or 24) off
			// bottom is 22 on, 23 off [22, 1], [
			key: \mode,
			shared: ( key: '_b1_', 'hidUsage': 1, 'hidUsagePage': 9, 'elementType': 'button', 'ioType': 'inout', 'spec': 'hidBut' ),
			elements: [22, 23, 24].collect { |num, i|
				( key: num.asSymbol, hidUsage: num,
					style: (row: i * 0.5 + 0.35, column: 0, height: 0.65)
				)
			}
		),
		(
			// F1 .. F4 buttons
			key: \F,
			shared: ( key: '_b1_', 'hidUsage': 1, 'hidUsagePage': 9, 'elementType': 'button', 'ioType': 'inout', 'spec': 'hidBut' ),
			elements: [17, 18, 19, 20].collect { |num, i|
				( key: (i+1).asSymbol, hidUsage: num,
					style: (row: 0, column: i + 1.33, height: 0.8)
				)
			}
		),
		(
			key: \joy,
			shared: ( 'hidUsagePage': 1, 'elementType': 'thumbAxis', 'ioType': 'inout',
				\spec: \unipolar
			),
			elements: [
				(key: 'x', 'hidUsage': 48, style: (row: 4, column: 4, width: 0.7)),
				(key: 'y', 'hidUsage': 49, style: (row: 4, column: 4.5, width: 0.7))
			]
		)
	]
)
);
