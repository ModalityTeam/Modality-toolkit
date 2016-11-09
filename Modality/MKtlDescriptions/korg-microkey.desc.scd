/*
MKtlDesc.loadDescs("*microkey"); m.free; m = MKtl(\nky2, "*microkey"); m.trace.guis;
*/
(
deviceName: "microKEY",
protocol: 'midi',
deviceType: \midiKeyboard,
elementTypes: [\pianoKey],
status: (
	linux: "unknown",
	osx: "tested desc, looks good. gui needs info. 2016_03_23, adc",
	win: "unknown"),

idInfo: "microKEY",

deviceInfo: (
	vendorURI: "http://www.korg.com/us/products/controllers/microkey/",
	// manualURI: "",
	// description: "",
	features: [
		"Velocity-sensitive mini-midiKeyboard",
		"three models: 25-key / 37-key / 61-key"
	],
	longName: "KORG microKEY"
	// notes: "",
),
elementsDesc: (
	shared: ('midiChan': 0),
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
							column: pos.x,
							color: pos.color,
							height: 1.2
					))
				);
			}
		),
		(
			key: 'mod',
			'midiMsgType': 'cc', 'elementType': 'modWheel', 'midiNum': 1,
			'spec': 'midiCC', style: (row: 0, column: 18, height: 2)
		),
		(
			key: 'bend',
			'midiMsgType': 'bend', 'elementType': 'bender',
			'spec': 'midiBend', style: (row: 0, column: 19, height: 2)
		)
	]
)
);