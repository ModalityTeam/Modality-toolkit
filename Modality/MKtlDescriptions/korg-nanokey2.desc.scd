/*
MKtlDesc.allDescs.clear;
m = MKtl(\nky2, "*nanokey2"); m.gui;
*/
(
deviceName: "nanoKEY2",
protocol: 'midi',
deviceType: \midiKeyboard,
elementTypes: [\pianoKey, \button],
status: (
	linux: "unknown",
	osx: "tested desc only, seems ok. 2016-03-23, adc",
	win: "unknown"),

idInfo: "nanoKEY2",

deviceInfo: (
	vendorURI: "http://www.korg.com/us/products/controllers/nanokey2/",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",
	longName: "KORG nanoKEY2"

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
			key: 'mod', 'elementType': 'modWheel',
			'midiMsgType': 'cc' , 'midiNum': 1, 'spec': 'midiCC',
			style: (row: 0, column: 18, height: 2)
		),
		(
			key: 'bend', 'elementType': 'bender', 'midiMsgType': 'bend',
			'spec': 'midiBend', style: (row: 0, column: 19, height: 2)
		)
	]
)
);
