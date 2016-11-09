///// nanoPAD2 desc file
/*
MKtlDesc.loadDescs("*nanopad2");
m.free; m = MKtl(\nky2, "*nanopad2"); m.gui;
*/
(
deviceName: "nanoPAD2",
protocol: \midi,
deviceType: \drumpad,
elementTypes: [\pad, \touchpad, \button],
status: (
	linux: "unknown",
	osx: "tested and working. 2016-03-22, dhml & adc",
	win: "unknown"),

idInfo: "nanoPAD2",

testCode: {
	MKtl.find(\midi);
	k = MKtl('np', "*nanopad2");
	k.gui;
	k.trace;
},

deviceInfo: (
	vendorURI: "http://www.korg.com/us/products/controllers/nanopad2/",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",
	longName: "KORG nanoPAD 2"

),
elementsDesc: (
	shared: ('midiChan': 0),
	elements: [
		(
			key: \pad,
			shared: ( elementType: \pad, \spec: \midiVel, \ioType: \in),
			elements: (36..99).clump(16).collect { |padbank, page|
				(
					shared: (page: page, groupType: \noteOnOff),
					elements: padbank.collect { |num, j|
						(
							key: i, midiNum: num,
							shared: (style: (row: j div: 8, column: j % 8 + 3))
						)
					}
				)
			}
		),
		(
			key: 'touch',
			shared: ('midiMsgType': 'cc', 'elementType': 'slider', style: (height: 2), 'spec': 'midiCC'),
			elements: [
				(key: \x, 'midiNum':   1, style: (height: 2, column: 0)),
				(key: \y, 'midiNum':   2, style: (height: 2, column: 1)),
				(key: \on, 'midiNum': 16, style: (height: 2, column: 2))
			]
		)
	]
)
)