//	// KORG nanoKONTROL2 specs:
//	// only cc messages,
(
idInfo: "nanoKONTROL2",
protocol: \midi,
description: [
	\rew -> (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 43, \spec: \midiBut, \mode: \push, \ioType: \inout),
	\fwd -> (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 44, \spec: \midiBut, \mode: \push, \ioType: \inout),
	\stop -> (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 42, \spec: \midiBut, \mode: \push, \ioType: \inout),
	\play -> (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 41, \spec: \midiBut, \mode: \push, \ioType: \inout),
	\rec -> (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 45, \spec: \midiBut, \mode: \push, \ioType: \inout),
	\cycle -> (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 46, \spec: \midiBut, \mode: \push, \ioType: \inout),
	\mset -> (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 60, \spec: \midiBut, \mode: \push, \ioType: \inout),
	\mleft -> (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 61, \spec: \midiBut, \mode: \push, \ioType: \inout),
	\mright -> (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 62, \spec: \midiBut, \mode: \push, \ioType: \inout),
	\tleft -> (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 58, \spec: \midiBut, \mode: \push, \ioType: \inout),
	\tright -> (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 59, \spec: \midiBut, \mode: \push, \ioType: \inout),

	// scene:
	\sl -> (0..7).collect{ |i|
		(\midiMsgType: \cc, \type: \slider, \midiChan: 0, \midiNum: i, \spec: \midiCC)
	},

	\kn -> (16..23).collect{ |i|
		(\midiMsgType: \cc, \type: \knob, \midiChan: 0, \midiNum: i, \spec: \midiCC)
	},

	\bt -> [(32..39),(48..55),(64..71)].collect{ |xs|
		xs.collect{ |i|
			(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum:  i, \spec: \midiCC, \ioType: \inout)
		}
	}
]
)