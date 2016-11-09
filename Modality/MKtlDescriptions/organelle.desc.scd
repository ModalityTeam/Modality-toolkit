// organelle desc
/*
d = MKtlDesc.loadDescs("organelle").first;
k.free; k = MKtl(\org, d); k.trace.gui;
*/

(
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
				(key: num.asSymbol, \midiNum: num,
					style: (row: 0, column: i * 1.5 + 1))
			}
		),
		(
			key: \bt,
			shared: (\elementType: \pad, \groupType: \noteOnOffBut, \spec: \midiBut),
			elements: (48..71).collect { |num, i|
				var pos = Piano.pos(num, 48);
				(key: i.asSymbol, midiNum: num,
					shared: (style: (
						row: 1 + (pos.y * 0.7),
						column: pos.x * 0.7 + 2,
						height: 0.7, width: 0.7
					),

					)
				);
			}
		),
		(	key: \alt, midiNum: 36,
			groupType: \noteOnOffBut,
			shared: (key: \alt, groupType: \noteOnOffBut, \elementType: \pad, \spec: \midiBut,
				style: (row: 1.6, column: 1.2, height: 0.7, width: 0.7)
			)
		),
		(
			key: \pedal,
			\elementType: \slider, \midiMsgType: \cc,
			\spec: \midiCC, \midiNum: 64, midiChan: 0,
			style: (row: 0, column: 0, height: 2)
		)
	]
)
)