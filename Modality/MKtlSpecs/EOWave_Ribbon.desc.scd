// EOWave_Ribbon
MKtl.addSpec( \midiBend, [0, 16384, \linear, 0, 0]);

[
	// ribbon
// [ noteOn, val, 127, num, 78, chan, 0, src, -1477523613 ]
// [ noteOff, val, 0, num, 78, chan, 0, src, -1477523613 ]
\ribbonTouch: (\midiType: \note, \type: \slider, \midiChan: 0, \midiNum: 36, \spec: \midiBut, \mode: \push),

//	\ribbonPos: (\midiType: \bend, \type: \slider, \midiChan: 0, \bendNum: 0, \spec: \midiBend, \mode: \push),

	// [ cc, val, 82, num, 7, chan, 0, src, -1477523613 ]
\ribbonPressure: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 7, \spec: \midiCC),

// expressionPad
// [ cc, val, 0, num, 1, chan, 0, src, -1477523613 ]
\expression: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 1, \spec: \midiCC)
]

