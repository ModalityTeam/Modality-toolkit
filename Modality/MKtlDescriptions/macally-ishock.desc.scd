/*
// todo:
* led control impossible on osx?

// test this desc:
~thisdesc= thisProcess.nowExecutingPath.basename.split($.).first.postcs;
d= MKtlDesc.loadDescs(~thisdesc).first;
m.free; m= MKtl(\gp, "*macally-ishock"); m.gui;
m.trace;
m.elementsDict.size;
m.postElements;
*/

(
idInfo: "Macally iShock_Macally ",
protocol: 'hid',
deviceName: "Macally iShock_Macally ",
deviceType: \gamepad,
elementTypes: [\joystick, \button, \wheel],
status: (
	linux: "unknown",
	osx: "tested and working. 2017-10-06, /f0",
	win: "unknown"
),

deviceInfo: (
// vendorURI: '',
// manualURI: '',
	// description: ,
	// features: [],
	// notes: ,
	// hasScribble: false
	longName: "Macally iShock Gamepad"
),
elementsDesc: (
	elements: [

		// --------- input elements ----------
		(
			key: \bt,
			shared: ('hidUsagePage': 9, 'elementType': 'button', 'ioType': 'in', 'spec': 'hidBut'),

			elements: [

				// shoulders
				(key: '15', 'hidUsage': 15,
					'style': (row: 0.5, column: 1.0, height: 0.5)),
				(key: '16', 'hidUsage': 16,
					'style': (row: 0.0, column: 1.0, height: 0.5)),
				(key: '13', 'hidUsage': 13,
					'style': (row: 0.5, column: 7.0, height: 0.5)),
				(key: '14', 'hidUsage': 14,
					'style': (row: 0.0, column: 7.0, height: 0.5)),

				// left (nsew)
				(key: '1', 'hidUsage': 1,
					'style': (row: 1.2, column: 1.0, height: 0.5)),
				(key: '2', 'hidUsage': 2,
					'style': (row: 2.4, column: 1.0, height: 0.5)),
				(key: '3', 'hidUsage': 3,
					'style': (row: 1.8, column: 0.2, height: 0.5)),
				(key: '4', 'hidUsage': 4,
					'style': (row: 1.8, column: 1.8, height: 0.5)),

				// right (discrete)
				(key: '5', 'hidUsage': 5,
					'style': (row: 1.2, column: 7.0, height: 0.5)),
				(key: '6', 'hidUsage': 6,
					'style': (row: 1.8, column: 7.8, height: 0.5)),
				(key: '7', 'hidUsage': 7,
					'style': (row: 2.4, column: 7.0, height: 0.5)),
				(key: '8', 'hidUsage': 8,
					'style': (row: 1.8, column: 6.2, height: 0.5)),

				// center (oval)
				(key: '9', 'hidUsage': 9,
					'style': (row: 1.8, column: 3.1, height: 0.5)),
				(key: '10', 'hidUsage': 10,
					'style': (row: 1.8, column: 4.0, height: 0.5)),
				(key: '11', 'hidUsage': 11,
					'style': (row: 1.8, column: 4.9, height: 0.5)),
				(key: '12', 'hidUsage': 12,
					'style': (row: 2.2, column: 4.0, height: 0.5)),

				// center left (round)
				(key: '19', 'hidUsage': 19,
					'style': (row: 1.3, column: 2.7, height: 0.5)),
				(key: '20', 'hidUsage': 20,
					'style': (row: 0.9, column: 2.0, height: 0.5))
			]
		),

		(
			key: 'joy',
			shared: ('ioType': 'in'),

			elements: [

				// left joystick
				(
					key: \l,
					elements: [
						(key: \x, 'hidUsage': 48, 'elementType': 'joyAxis', 'hidUsagePage': 1,
							spec: \cent1, mode: \center, 'style': (row: 3.5, column: 2.0, height: 2.0)),
						(key: \y, 'hidUsage': 49, 'elementType': 'joyAxis', 'hidUsagePage': 1,
							spec: \cent1inv, mode: \center, 'style': (row: 3.5, column: 2.9, height: 2.0)),
						(key: \hat, 'hidUsage': 17, 'elementType': 'button', 'hidUsagePage': 9,
							spec: \hidBut, mode: \push, 'style': (row: 2.9, column: 2.5, height: 0.75))
					]
				),

				// right joystick
				(
					key: \r,
					elements: [
						(key: \x, 'hidUsage': 53, 'elementType': 'joyAxis', 'hidUsagePage': 1,
							spec: \cent1inv, mode: \center, 'style': (row: 3.5, column: 5.0, height: 2.0)),
						(key: \y, 'hidUsage': 54, 'elementType': 'joyAxis', 'hidUsagePage': 1,
							spec: \cent1inv, mode: \center, 'style': (row: 3.5, column: 5.9, height: 2.0)),
						(key: \hat, 'hidUsage': 18, 'elementType': 'button', 'hidUsagePage': 9,
							spec: \hidBut, mode: \push, 'style': (row: 2.9, column: 5.5, height: 0.75))
					]
				)
			]
		)

		// --------- output elements ----------

	]
)
);
