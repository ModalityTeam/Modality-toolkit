// Behringer BCR2000 specs: 

[
	\pr_1_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 105, \spec: \midiBut, \mode: \toggle, \ioType: \inout),
	\pr_1_2: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 106, \spec: \midiBut, \mode: \toggle, \ioType: \inout),
	\pr_2_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 107, \spec: \midiBut, \mode: \toggle, \ioType: \inout),
	\pr_2_2: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 108, \spec: \midiBut, \mode: \toggle, \ioType: \inout)
]
++
8.collect{ |i|

	//4 encoder groups
	4.collect{ |j|
		// top knob push mode
		[( "tr_" ++ (j+1) ++ "_" ++ (i+1) ).asSymbol,(\midiType: \cc, \type: \encoder, \midiChan: 0, \midiNum: 33+(8*j)+i, \spec: \midiCC, \ioType: \in),
		// knobs (top row)
		( "kn_" ++ (j+1) ++ "_" ++ (i+1) ).asSymbol,(\midiType: \cc, \type: \encoder, \midiChan: 0, \midiNum: 1+(8*j)+i, \spec: \midiCC, \ioType: \inout)]
	}
	++
	[
		("bt_1_"++(i+1)).asSymbol,(\midiType: \cc, \type: \midiBut, \midiChan: 0, \midiNum: 65+i, \spec: \midiCC, \ioType: \inout),
		("bt_2_"++(i+1)).asSymbol,(\midiType: \cc, \type: \midiBut, \midiChan: 0, \midiNum: 73+i, \spec: \midiCC, \ioType: \inout),
		("kn_5_"++(i+1)).asSymbol,(\midiType: \cc, \type: \encoder, \midiChan: 0, \midiNum: 81+i, \spec: \midiCC, \ioType: \inout),
		("kn_6_"++(i+1)).asSymbol,(\midiType: \cc, \type: \encoder, \midiChan: 0, \midiNum: 89+i, \spec: \midiCC, \ioType: \inout),
		("kn_7_"++(i+1)).asSymbol,(\midiType: \cc, \type: \encoder, \midiChan: 0, \midiNum: 97+i, \spec: \midiCC, \ioType: \inout)
	]
}.flat