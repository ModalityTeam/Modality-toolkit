(
deviceName: "Thrustmaster dual analog 3.2_Thrustmaster",
protocol: \hid,
deviceType: \gamepad,
elementTypes: [\joystick, \button, \wheel, \throttle, \compass],
status: (
	linux: "tested by bgola 12.04.2024",
	osx: "unknown",
	win: "unknown"),

idInfo: "Thrustmaster dual analog 3.2_Thrustmaster",

deviceInfo: (
	vendorURI: "https://support.thrustmaster.com/en/product/dualanalog4-en/",
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
				(key: '1', 'hidUsage': 1, 'style': (row: 2.6, column: 5.2)),
				(key: '2', 'hidUsage': 2, 'style': (row: 1.8, column: 4.4)),
				(key: '3', 'hidUsage': 3, 'style': (row: 1.8, column: 6.0)),
				(key: '4', 'hidUsage': 4, 'style': (row: 1.0, column: 5.2)),
				// shoulders
				(key: '5', 'hidUsage': 5, 'style': (row: 0, column: 1)),
				(key: '7', 'hidUsage': 7, 'style': (row: 0, column: 5)),
				// underside
				(key: '6', 'hidUsage': 6, 'style': (row: 0, column: 2.5)),
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
							mode: \center, 'style': (row: 4.1, column: 1, height: 0.7, width: 1.5)
						),
						(key: \y, 'hidUsage': 49, 'elementType': 'joyAxis', spec: \cent1,
							mode: \center, 'style': (row: 3.2, column: 2.4, height: 1.5, width: 0.7)
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
						(key: \x, 'hidUsage': 53, 'elementType': 'joyAxis', spec: \cent1,
							mode: \center, 'style': (row: 4.1, column: 3, height: 0.7, width: 1.5)
						),
						(key: \y, 'hidUsage': 54, 'elementType': 'joyAxis', spec: \cent1,
							mode: 'center', 'style': (row: 3.2, column: 4.5, height: 1.5, width: 0.7)
						),
						(key: \hat, 'hidUsage': 12, 'hidUsagePage': 9, 'elementType': 'button',
							spec: \hidBut, mode: \push,
							'style': (row: 3.2, column: 3.5)
						)
					]
				)
			]
		),
	]
);
)