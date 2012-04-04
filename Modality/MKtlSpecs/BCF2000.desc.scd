// Behringer BCF2000 specs: 

[
	\pr_1_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 89, \spec: \midiBut, \mode: \toggle),
	\pr_1_2: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 90, \spec: \midiBut, \mode: \toogle),
	\pr_2_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 91, \spec: \midiBut, \mode: \toogle),
	\pr_2_2: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 92, \spec: \midiBut, \mode: \toogle)
]
++
8.collect{ |i|

	//4 encoder groups
    4.collect{ |j|
		// top knob push mode
		[( "tr_" ++ (j+1) ++ "_" ++ (i+1) ).asSymbol,(\midiType: \cc, \type: \encoder, \chan: 0, \ccNum: 33+(8*j)+i, \spec: \midiCC, \ioType: \in),
		// knobs (top row)
		( "kn_" ++ (j+1) ++ "_" ++ (i+1) ).asSymbol,(\midiType: \cc, \type: \encoder, \chan: 0, \ccNum: 1+(8*j)+i, \spec: \midiCC, \ioType: \inout)]
	}
	++
	[
		("bt_1_"++(i+1)).asSymbol,(\midiType: \cc, \type: \midiBut, \chan: 0, \ccNum: 65+i, \spec: \midiCC),
		("bt_2_"++(i+1)).asSymbol,(\midiType: \cc, \type: \midiBut, \chan: 0, \ccNum: 73+i, \spec: \midiCC),
		("sl"++(i+1)).asSymbol,(\midiType: \cc, \type: \encoder, \chan: 0, \ccNum: 81+i, \spec: \midiCC)

	]
}.flat