/*
needs initialisation messages for different configs,
see github/modality #24
*/
(
deviceName: "The Ribbon",
protocol: \midi,
deviceType: \ribbon,
elementTypes: [\ribbon, \pad],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "The Ribbon",

deviceInfo: (
	vendorURI: "http://www.eowave.com/instruments.php?prod=78",
	manualURI: "http://www.eowave.com/downloads/pdf/EowaveRibbon_manual.pdf",
	// description: "",
	features: [
		"pressure and postition sensitive ribbon",
		"capacitive sensing touch field",
	],
	// notes: "",
	// hasScribble: false
),

elementsDesc: (
	elements: [
	// ribbon
	// [ noteOn, val, 127, num, 78, chan, 0, src, -1477523613 ]
	// [ noteOff, val, 0, num, 78, chan, 0, src, -1477523613 ]
		(
			key: \ribbon,
			shared: (midiChan: 0),
			elements: [
				(
					key: \touch,
					shared: (elementType: \slider, midiMsgType: \noteOnOff,
						spec: \midiBut),
					elements: (36..82).collect {|num| (midiNum: num, spec: \midiBut) }
				),
				(
					key: \bend,
					midiMsgType: \bend, elementType: \slider, midiNum: 0, spec: \midiBend
				),
				(
					key: \pressure,
					midiMsgType: \cc, elementType: \slider, midiNum: 7, spec: \midiCC
				),
				// expressionPad
				// [ cc, val, 0, num, 1, chan, 0, src, -1477523613 ]
				(
					key: \pad,
					midiMsgType: \cc, elementType: \pad, midiNum: 1, spec: \midiCC
				)
			]
		)
	]
)
)


