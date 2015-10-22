MKtl.addSpec(\compassShanWan, [0, 7]);

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
	// vendorURI: "",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",

	// hasScribble: false
),
elementsDesc: (
// --------- input elements ----------
	elements: [
		(
			key: \triangle, 'hidUsage': 1, 'hidUsagePage': 9, 'type': 'button',
			'ioType': 'in', spec: \hidBut, mode: \push ),
		(
			key: \circle, 'hidUsage': 2, 'hidUsagePage': 9, 'type': 'button',
			'ioType': 'in', spec: \hidBut, mode: \push ),
		(
			key: 'cross', 'hidUsage': 3, 'hidUsagePage': 9, 'type': 'button',
			'ioType': 'in', spec: \hidBut, mode: \push ),
		(
			key: 'square', 'hidUsage': 4, 'hidUsagePage': 9, 'type': 'button',
			'ioType': 'in', spec: \hidBut, mode: \push ),
		(
			key: 'sh',
			shared: ('hidUsagePage': 9, 'type': 'button', 'ioType': 'in',
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
			key: 'select', 'hidUsage': 9, 'hidUsagePage': 9, 'type': 'button',
			'ioType': 'in', spec: \hidBut, mode: \push ),
		(
			key: 'start', 'hidUsage': 10, 'hidUsagePage': 9, 'type': 'button',
			'ioType': 'in', spec: \hidBut, mode: \push ),
		(
			key: 'mode', 'hidUsage': 1, 'hidUsagePage': 65280, 'type': 'button',
			'ioType': 'in', spec: \hidBut, mode: \push ),
		(
			key: 'joy',
			shared: ('ioType': 'in'),
			elements: [
				(
					key: 'l',
					elements: [
						(
							key: 'x', 'hidUsage': 48, 'hidUsagePage': 1, 'type': 'joyAxis',
							spec: \cent1, mode: \center  ),
						(
							key: 'y', 'hidUsage': 49, 'hidUsagePage': 1, 'type': 'joyAxis',
							'ioType': 'in', spec: \cent1, mode: \center  ),
						(
							key: 'hat', 'hidUsage': 11, 'hidUsagePage': 9, 'type': 'button',
							'ioType': 'in', spec: \hidBut, mode: \push )
					]
				),
				(
					key: 'l',
					elements: [
						(
							key: 'x', 'hidUsage': 50, 'hidUsagePage': 1, 'type': 'joyAxis',
							spec: \cent1, mode: \center  ),
						(
							key: 'y', 'hidUsage': 53, 'hidUsagePage': 1, 'type': 'joyAxis',
							'ioType': 'in', spec: \cent1, mode: \center  ),
						(
							key: 'hat', 'hidUsage': 12, 'hidUsagePage': 9, 'type': 'button',
							'ioType': 'in', spec: \hidBut, mode: \push )
					]
				)
			]
		),
		(
			key: 'compass',
			'hidUsage': 57, 'hidUsagePage': 1, 'type': 'compass', 'ioType': 'in',
			spec: \compassShanWan, mode: \center),

		// --------- output elements ----------
		(
			key: 'modeOut', 'hidUsage': 2, 'hidUsagePage': 65280, 'type': 'option',
				'ioType': 'out', spec: \lin255, mode: \minimum ),
		(
			key: 'rumble1', 'hidElementID': 19, 'type': 'rumble', 'ioType': 'out',
			spec: \lin255, mode: \minimum ),
		(
			key: 'rumble2', 'hidElementID': 20, 'type': 'rumble', 'ioType': 'out',
			spec: \lin255, mode: \minimum ),
		(
			key: 'rumble3', 'hidElementID': 21, 'type': 'rumble', 'ioType': 'out',
			spec: \lin255, mode: \minimum ),
		(
			key: 'rumble4', 'hidElementID': 22, 'type': 'rumble', 'ioType': 'out',
			spec: \lin255, mode: \minimum )
	]
)
);