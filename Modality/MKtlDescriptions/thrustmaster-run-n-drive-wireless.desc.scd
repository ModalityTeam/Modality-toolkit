/*

Notes:
* rumble does nothing on wireless, works on wired.

-- elementsDesc copied over from plain run_n_drive
-- only differences:
	deviceName: "Run'N' Drive Wireless_Thrustmaster",
	idInfo: "Run'N' Drive Wireless_Thrustmaster",
-- could be unified by loading dict from "runndrive-dict.scd",
-- and then modifiying deviceName and idInfo only

-- for examples, see also plain run-n-drive

f = MKtl('f', "*drive-wireless");
f.gui;
f.postElements;
f.trace;
f.device.source.elements[32].value_(255)

*/

(
deviceName: "Run'N' Drive Wireless_Thrustmaster",
protocol: \hid,
deviceType: \gamepad,
elementTypes: [\joystick, \button, \wheel, \throttle, \compass, \rumble],
status: (
	linux: "unknown",
	osx: "tested and working. 2016-03-16, adc",
	win: "unknown"),

idInfo: "Run'N' Drive Wireless_Thrustmaster",

deviceInfo: (
	vendorURI: "http://www.thrustmaster.com/products/runndrive-wireless-3-in1-rumble-force",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",

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
		// only working on wired version

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
					'hidUsage': 0, 'hidUsagePage': 1, hidElementID: 32,
					'style': (row: 4, column: 5)
				)
			]
		)
	]
)
)