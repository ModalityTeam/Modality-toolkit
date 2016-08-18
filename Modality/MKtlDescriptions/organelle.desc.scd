// organelle desc
/*
MKtl(\org, d);
MKtl(\org).rebuild(d);
MKtl(\org).gui;

1 / 1.4
*/

d = (
	deviceName: "organelle",
	protocol: \midi,
	deviceType: \organelle,
	elementTypes: [\pad, \knob],

	// status: (
	// 	osx: "tested and working, 2016_03_15, adc",
	// 	linux: "tested and working 2016_03_20, nescivi",
	// 	win: "unknown"
	// ),

	idInfo: "organelle",

	deviceInfo: (
		vendorURI: "https://www.critterandguitari.com/pages/organelle",
		//	manualURI: "https://www.critterandguitari.com/pages/organelle",
		description: "ARM-based standalone linux box with midi control",
		features: [
			"25 wooden note-buttons",
			"4 knobs",
			"1 expression pedal input",
			"1 alt-button w status LED",
			"1 mode-switching knob (e.g. to change PD patches)"
			"1 volume knob (analog only, no midi)"
		],
		notes: "",
		longName: "C&G organelle"
	),

	elementsDesc: (
		'shared': (\ioType: \inout, midiChan: 0),

		elements: [
			(
				key: \kn,
				shared: (\elementType: \knob, \midiMsgType: \cc,
					\spec: \midiCC),
				elements: (1..4).collect { |num, i|
					(key: num.asSymbol, \midiNum: num, style: (row: 0, column: i * 2))
				}
			),
			(
				key: \but,
				shared: (\elementType: \pad, \spec: \midiVel),
				elements: (48..71).collect { |num, i|
					var index = [0, 0.5, 1, 1.5, 2, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5][i%12] + (i div: 12 * 6);
					var black = [1, 3, 6, 8, 10].includes(i%12).binaryValue;
					MKtlDesc.notePair(
						(i+1).asSymbol, num,
						shared: (style: (
							row: 2.5 - black, // upper row is black keys
							column: index + 2)
						)
					);
				}
			),
			MKtlDesc.notePair(\alt, 36,
				shared: (key: \alt, \elementType: \pad, \spec: \midiBut,
					style: (row: 2.5, column: 1)
				)
			),
			(
				key: \pedal,
				\elementType: \slider, \midiMsgType: \cc,
				\spec: \midiCC, \midiNum: 64, midiChan: 0,
				style: (row: 1, column: 0, height: 2)
			)
		]
	)
)