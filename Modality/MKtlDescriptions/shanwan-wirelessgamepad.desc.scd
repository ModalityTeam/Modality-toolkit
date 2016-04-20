
(
deviceName: "USB WirelessGamepad _ShanWan",
protocol: 'hid',
deviceType: \gamepad,
elementTypes: [\button, \joyAxis, \compass],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "USB WirelessGamepad _ShanWan",

deviceInfo: (
	// vendorURI: "http://",
	// manualURI: "http://",
	// description: "",
	// features: [
	// ],
	longName: "ShanWan Wireless GamePad"
),
elementsDesc: (
// --------- input elements ----------
	elements: [
		(
			key: \triangle, 'hidUsage': 1, 'hidUsagePage': 9, 'elementType': 'button',
			'ioType': 'in', spec: \hidBut, mode: \push ),
		(
			key: \circle, 'hidUsage': 2, 'hidUsagePage': 9, 'elementType': 'button',
			'ioType': 'in', spec: \hidBut, mode: \push ),
		(
			key: 'cross', 'hidUsage': 3, 'hidUsagePage': 9, 'elementType': 'button',
			'ioType': 'in', spec: \hidBut, mode: \push ),
		(
			key: 'square', 'hidUsage': 4, 'hidUsagePage': 9, 'elementType': 'button',
			'ioType': 'in', spec: \hidBut, mode: \push ),
		(
			key: 'sh',
			shared: ('hidUsagePage': 9, 'elementType': 'button', 'ioType': 'in',
				spec: \hidBut, mode: \push),
			elements: [
				(key: 'l',
					elements: [
						(key: \1, 'hidUsage': 5),
						(key: \2, 'hidUsage': 7),
					]
				),
				(key: 'r',
					elements: [
						(key: \1, 'hidUsage': 6),
						(key: \2, 'hidUsage': 8),
					]
				)
			]
		),
		(
			key: 'select', 'hidUsage': 9, 'hidUsagePage': 9, 'elementType': 'button',
			'ioType': 'in', spec: \hidBut, mode: \push ),
		(
			key: 'start', 'hidUsage': 10, 'hidUsagePage': 9, 'elementType': 'button',
			'ioType': 'in', spec: \hidBut, mode: \push ),
		(
			key: 'mode', 'hidUsage': 1, 'hidUsagePage': 65280, 'elementType': 'button',
			'ioType': 'in', spec: \hidBut, mode: \push ),
		(
			key: 'joy',
			shared: ('ioType': 'in'),
			elements: [
				(
					key: 'l',
					elements: [
						(
							key: 'x', 'hidUsage': 48, 'hidUsagePage': 1, 'elementType': 'joyAxis',
							spec: \cent1, mode: \center  ),
						(
							key: 'y', 'hidUsage': 49, 'hidUsagePage': 1, 'elementType': 'joyAxis',
							'ioType': 'in', spec: \cent1, mode: \center  ),
						(
							key: 'hat', 'hidUsage': 11, 'hidUsagePage': 9, 'elementType': 'button',
							'ioType': 'in', spec: \hidBut, mode: \push )
					]
				),
				(
					key: 'l',
					elements: [
						(
							key: 'x', 'hidUsage': 50, 'hidUsagePage': 1, 'elementType': 'joyAxis',
							spec: \cent1, mode: \center  ),
						(
							key: 'y', 'hidUsage': 53, 'hidUsagePage': 1, 'elementType': 'joyAxis',
							'ioType': 'in', spec: \cent1, mode: \center  ),
						(
							key: 'hat', 'hidUsage': 12, 'hidUsagePage': 9, 'elementType': 'button',
							'ioType': 'in', spec: \hidBut, mode: \push )
					]
				)
			]
		),
		(
			key: 'compass',
			'hidUsage': 57, 'hidUsagePage': 1, 'elementType': 'compass', 'ioType': 'in',
			spec: \unipolar, mode: \center),

		// --------- output elements ----------
		(
			key: 'modeOut', 'hidUsage': 2, 'hidUsagePage': 65280, 'elementType': 'option',
				'ioType': 'out', spec: \lin255, mode: \minimum ),
		(
			key: 'rumble1', 'hidElementID': 19, 'elementType': 'rumble', 'ioType': 'out',
			spec: \lin255, mode: \minimum ),
		(
			key: 'rumble2', 'hidElementID': 20, 'elementType': 'rumble', 'ioType': 'out',
			spec: \lin255, mode: \minimum ),
		(
			key: 'rumble3', 'hidElementID': 21, 'elementType': 'rumble', 'ioType': 'out',
			spec: \lin255, mode: \minimum ),
		(
			key: 'rumble4', 'hidElementID': 22, 'elementType': 'rumble', 'ioType': 'out',
			spec: \lin255, mode: \minimum )
	]
)
);