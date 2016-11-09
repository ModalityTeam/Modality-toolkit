// M-audio Trigger finger - MKtl

/*
MKtlDesc.loadDescs("*finger"); m.free; m = MKtl('op1', "*finger"); m.trace.gui;
*/

(
deviceName: "USB Trigger Finger",
protocol: \midi,
deviceType: \drumpad,
elementTypes: [\pad, \button, \slider],
status: (
	linux: "unknown",
	osx: "tested desc, looks good. needs gui layout. 2016_03_23, adc",
	win: "unknown"),

idInfo: "USB Trigger Finger",

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	// description: "",
	features: [\pad, \slider, \knob],
	// notes: "",
	longName: "M-AUDIO Trigger Finger"
),
elementsDesc: (
	shared: (\midiChan: 0, ioType: \in),
	elements: [
		(
			key: \kn,
			shared: ( elementType: \knob, \midiMsgType: \cc,
				spec: \midiCC),
			elements: ( #[10, 91, 12, 93, 5, 73, 84, 72].collect { |num, i|
				(key: (i + 1).asSymbol, \midiNum: num,
					style: (row: 0.5 - (i div: 4 * 0.8),
						column: (i % 4 * 0.9) + 3 + (i div: 4 * 0.5)
					)
				)
			})
		),
		(
			key: \sl,
			shared: ( elementType: \slider, \midiMsgType: \cc,
				spec: \midiCC),
			elements: #[7, 1, 71, 74].collect { |num, i|
				(key: (i + 1).asSymbol, \midiNum: num,
					style: (row: 3, column: i * 0.75, width: 0.8)
				)
			}
		),
		(
			key: \pad,
			shared: ( elementType: \pad, \groupType: \noteOnOff,
				spec: \midiVel),
			elements: ((0..15) + 35).collect { |num, i|
				(key: (i + 1).asSymbol, \midiNum: num,
					shared: (style: (
						column: i % 4 + 3,
						row:  5 - (i div: 4)
					))
				)
			}
		),
	]
)
)

// pads * 16
// [35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51]

// sliders * 4
// [7, 1, 71, 74]

// knobs * 8
// [10, 91, 12, 93, 5, 73, 84, 72]

