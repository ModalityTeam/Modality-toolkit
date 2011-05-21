// Behringer BCF2000 specs: 

[
	\prA1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 89, \spec: \midiBut, \mode: \toggle),
	\prA2: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 90, \spec: \midiBut, \mode: \toogle),
	\prB1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 91, \spec: \midiBut, \mode: \toogle),
	\prB2: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 92, \spec: \midiBut, \mode: \toogle)
]
++
8.collect{ |i|

	//4 encoder groups
	4.collect{ |j|
		// top knob push mode
		[( "tr" ++ ["A","B","C","D"][j] ++ (i+1) ).asSymbol,(\midiType: \cc, \type: \encoder, \chan: 0, \ccNum: 33+(8*j)+i, \spec: \midiCC),
		// knobs (top row)
		( "kn" ++ ["A","B","C","D"][j] ++ (i+1) ).asSymbol,(\midiType: \cc, \type: \encoder, \chan: 0, \ccNum: 1+(8*j)+i, \spec: \midiCC)]
	}
	++
	[
		("btA"++(i+1)).asSymbol,(\midiType: \cc, \type: \midiBut, \chan: 0, \ccNum: 65+i, \spec: \midiCC),
		("btB"++(i+1)).asSymbol,(\midiType: \cc, \type: \midiBut, \chan: 0, \ccNum: 73+i, \spec: \midiCC),
		("sl"++(i+1)).asSymbol,(\midiType: \cc, \type: \encoder, \chan: 0, \ccNum: 81+i, \spec: \midiCC)

	]
}.flat