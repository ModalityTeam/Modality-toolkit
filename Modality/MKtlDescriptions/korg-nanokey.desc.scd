/*
MKtlDesc.loadDescs("*nanokey");
m.free; m = MKtl(\nky, "*nanokey"); m.trace.gui;
*/

(
(
deviceName: "nanoKEY",
protocol: 'midi',
deviceType: \midiKeyboard,
elementTypes: [\pianoKey],
status: (
	linux: "unknown",
	osx: "tested and working. 2015-03-15, adc",
	win: "unknown"),

idInfo: "nanoKEY",

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",

	longName: "KORG nanoKEY"
),
elementsDesc: (
	shared: (midiChan: 0),
	elements: [
		(
			key: \pkey,
			shared: ('elementType': 'pianoKey', groupType: \noteOnOff, spec: \midiVel),
			elements: (0..120).collect { |midinum, i|
				var pos = Piano.pos(midinum % 48, 0);
				(key: i.asSymbol,
					midiNum: midinum,
					shared: (
						groupType: \noteOnOff,
						style: (
							row: (4 - (i div: 48 * 2)) + (pos.y * 0.9),
							column: pos.x * 0.8,
							color: pos.color,
							height: 1.2
					))
				);
			}
		),
		(
			key: \mod,
			'midiMsgType': 'cc', 'elementType': 'button', 'midiNum': 1,'spec': 'midiBut'
		),
		// where do these come from? keys as cc?
		(
			key: \cc,
			shared: ('midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
			elements: ((14..31) ++ (80..87)).collect { |midinum, i|
				('midiNum': midinum, style: (height: 2, row: 6, column: i))
			}
		),
		(
			key: \bend,
			'midiMsgType': 'bend', 'elementType': 'button', 'spec': 'midiBend',
			style: (row: 0, column: 12, width: 2)
		)
	]
)
)
)