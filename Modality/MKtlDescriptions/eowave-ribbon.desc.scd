/*
needs initialisation messages for different configs,
see github/modality #24
MKtlDesc.loadDescs("eowave*");
m.free; m = MKtl(\eo, "eowave*").trace.gui;
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
	longName: "EOWave Ribbon (v.1)"
	// notes: "",

),

elementsDesc: (
	shared: (midiChan: 0),
	elements: [
		// ribbon
		// [ noteOn, val, 127, num, 78, chan, 0, src, -1477523613 ]
		// [ noteOff, val, 0, num, 78, chan, 0, src, -1477523613 ]
		(
			key: \rib,
			shared: (elementType: \pad, groupType: \noteOnOffBut, spec: \midiBut),
			elements: (36..82).collect {|num, i|
				(key: i, midiNum: num, shared:
					(style: (row: 0, column: i * 0.8, height: 1.5, width: 0.9,
						showLabel: true, label: i)))
			}
		),
		(
			key: \bend,
			midiMsgType: \bend, elementType: \slider, midiNum: 0, spec: \midiBend,
			style: (row: 1.5, column: 3, width: 4, height: 1)
		),
		(
			key: \pressure,
			midiMsgType: \cc, elementType: \slider, midiNum: 7, spec: \midiCC,
			style: (row: 1.5, column: 8, width: 4, height: 1)
		),
		// expressionPad
		// [ cc, val, 0, num, 1, chan, 0, src, -1477523613 ]
		(
			key: \pad,
			midiMsgType: \cc, elementType: \pad, midiNum: 1, spec: \midiCC,
			style: (row: 1.5, column: 0, width: 2)
		)
	]
)
)


