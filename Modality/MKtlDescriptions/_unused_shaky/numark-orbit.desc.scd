/*
* todo: enter gui positions of elements!

m = MKtl(\orb, "*orbit");
m.gui;
MKtl.addSpec(\selectNumark, [0, 4]);

*/

(
deviceName: "Numark ORBIT",
protocol: 'midi',
deviceType: \djController,
elementTypes: [\button, \encoder],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "Numark ORBIT",

deviceInfo: (
	vendorURI: "http://www.numark.com/product/orbit",
	// manualURI: "",
	// description: "",
	features: [
		"wireless",
		"16 backlit pads",
		"4 banks",
		"4 knobs per bank",
		"2-axis accelerometer",
		"control wheel",
	],
	// notes: "",
),
elementsDesc: (
	elements: [
		(
			key: 'pad',
			shared: ('elementType': 'pad',  'spec': 'midiVel'),
			elements: 4.collect { arg chan;
				(
					shared: ('midiChan': chan),
					elements: (36..51).collect { arg num, i;
						MKtlDesc.notePair(
							(i+1).asSymbol, num,
							// add style for pad layout..
							(style: (row: i, column: 0))
						)

					}
				)
			}
		),
		(
			key: 'sh',
			shared: ('type': 'key', 'midiChan': 15,'spec': 'midiVel'),
			elements: [
				MKtlDesc.notePair('l', 3, (style: (row: 3, column: 0))
				),
				MKtlDesc.notePair('r', 4, (style: (row: 4, column: 0))
				),
			]
		),
		// ------ cc -------------
		(
			key: 'dial',
			shared: ('midiMsgType': 'cc', 'type': 'dial',
				'spec': 'midiCC', 'midiNum':  4),
			elements: 4.collect { arg chan; ('midiChan': chan) }
		),
		(
			key: 'move',
			shared: ('midiMsgType': 'cc', 'type': 'movement',
				'spec': 'midiCC'),
			elements: 4.collect { arg chan;
				(
					shared: ('midiChan': chan),
					elements: [
						(key: 'l', 'midiNum':  9),
						(key: 'r', 'midiNum':  10)
					]
				)
			}
		),
		(
			key: 'k',
			'midiMsgType': 'cc', 'type': 'button', 'midiChan': 15,
			'midiNum':  2,'spec': 'selectNumark'),
		(
			key: 'padbank',
			'midiMsgType': 'cc', 'type': 'slider', 'midiChan': 15,
			'midiNum':  1,'spec': 'selectNumark')
	]
)
)