(
device: "The Ribbon",
protocol: \midi,
decription: (
	// ribbon
	// [ noteOn, val, 127, num, 78, chan, 0, src, -1477523613 ]
	// [ noteOff, val, 0, num, 78, chan, 0, src, -1477523613 ]
	\ribbonTouch: (\midiType: \noteOnOff, \type: \slider, \midiChan: 0, \midiNum: 36, \spec: \midiBut, \mode: \push),

	\ribbonPos: (\midiType: \bend, \type: \slider, \midiChan: 0, \midiNum: 0, \spec: \midiBend),

	// [ cc, val, 82, num, 7, chan, 0, src, -1477523613 ]
	\ribbonPress: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 7, \spec: \midiCC),

	// expressionPad
// [ cc, val, 0, num, 1, chan, 0, src, -1477523613 ]
	\expression: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 1, \spec: \midiCC)
)
)
