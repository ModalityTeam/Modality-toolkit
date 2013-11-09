// Behringer BCF2000 specs: 

[
	\pr_1_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 89, \spec: \midiBut, \mode: \toggle),
	\pr_1_2: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 90, \spec: \midiBut, \mode: \toogle),
	\pr_2_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 91, \spec: \midiBut, \mode: \toogle),
	\pr_2_2: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 92, \spec: \midiBut, \mode: \toogle)
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
		("bt_1_"++(i+1)).asSymbol,(\midiType: \cc, \type: \midiBut, \midiChan: 0, \midiNum: 65+i, \spec: \midiCC),
		("bt_2_"++(i+1)).asSymbol,(\midiType: \cc, \type: \midiBut, \midiChan: 0, \midiNum: 73+i, \spec: \midiCC),
		("sl"++(i+1)).asSymbol,(\midiType: \cc, \type: \encoder, \midiChan: 0, \midiNum: 81+i, \spec: \midiCC)

	]
}.flat