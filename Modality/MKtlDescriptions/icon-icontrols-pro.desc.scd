// incomplete, but what is there works

(
deviceName: "iCON iControls_Pro V1.02",
protocol: \midi,
deviceType: \faderbox,
elementTypes: [\fader, \button],
status: "unknown",

idInfo: "iCON iControls_Pro V1.02",

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",

	// hasScribble: false
),
description: [

	\bt -> [
		\rec -> 8.collect { |i|
			(\midiMsgType: \noteOnOff, \type: \button, \ioType: \inout, \midiChan: 0, \midiNum: i, \spec: \midiVel, \mode: \push )
		},
		\solo -> 8.collect { |i|
			(\midiMsgType: \noteOnOff, \type: \button, \ioType: \inout, \midiChan: 0, \midiNum: i+8, \spec: \midiVel, \mode: \push )
		},
		\mute -> 8.collect { |i|
			(\midiMsgType: \noteOnOff, \type: \button, \ioType: \inout, \midiChan: 0, \midiNum: i+16, \spec: \midiVel, \mode: \push )
		},
		\select -> 8.collect { |i|
			(\midiMsgType: \noteOnOff, \type: \button, \ioType: \inout, \midiChan: 0, \midiNum: i+16, \spec: \midiVel, \mode: \push )
		},
	],

	\kn -> 8.collect{ |i|
		(\midiMsgType: \cc, \type: \encoder, \ioType: \inout,
			\midiChan: 0, \midiNum: i+16, \spec: \midiVel, \mode: \mackie )
	},

	\sl -> 9.collect { |i|
		(\midiMsgType: \bend, \type: \slider, \ioType: \inout, \midiChan: i, \spec: \midiBend)
	}
]
)