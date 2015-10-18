// M-audio Trigger finger - MKtl

(
deviceName: "USB Trigger Finger",
protocol: \midi,
deviceType: \drumpad,
elementTypes: [\pad, \button, \slider],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "USB Trigger Finger",

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	// description: "",
	features: [\pad, \slider, \knob],
	// notes: "",

	// hasScribble: false
),
elementsDesc: (
	elements: [
		\pad -> (
			sharedProperties: ( elementType: \pad, \midiMsgType: \note,
				spec: \midiVel, \midiChan: 0),
			elements: ((0..15) + 35).collect { |num, i|
				(i + 1).asSymbol -> (\midiNum: num)
			}
		),
		\sl -> (
			sharedProperties: ( elementType: \slider, \midiMsgType: \cc,
				spec: \midiCC, \midiChan: 0),
			elements: ( #[7, 1, 71, 74].collect { |num, i|
				(i + 1).asSymbol -> (\midiNum: num )
			})
		),
		\kn -> (
			sharedProperties: ( elementType: \knob, \midiMsgType: \cc,
				spec: \midiCC, \midiChan: 0),
			elements: ( #[10, 91, 12, 93, 5, 73, 84, 72].collect { |num, i|
				(i + 1).asSymbol -> (\midiNum: num )
			})
		)
	]
)
)

// pads * 16
// [35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51]

// sliders * 4
// [7, 1, 71, 74]

// knobs * 8
// [10, 91, 12, 93, 5, 73, 84, 72]

