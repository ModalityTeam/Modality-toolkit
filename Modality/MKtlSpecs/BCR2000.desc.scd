// Behringer BCR2000 specs: 

[
	\prA1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 105, \spec: \midiBut, \mode: \toggle),
	\prA2: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 106, \spec: \midiBut, \mode: \toggle),
	\prB1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 107, \spec: \midiBut, \mode: \toggle),
	\prB2: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 108, \spec: \midiBut, \mode: \toggle)
]
++
8.collect{ |i|

	//4 encoder groups
	4.collect{ |j|
		// top knob push mode
		[( "tr" ++ ["A","B","C","D"][j] ++ (i+1) ).asSymbol,(\midiType: \cc, \type: \encoder, \chan: 0, \ccNum: 33+(8*j)+i, \spec: \midiCC, \ioType: \in),
		// knobs (top row)
		( "kn" ++ ["A","B","C","D"][j] ++ (i+1) ).asSymbol,(\midiType: \cc, \type: \encoder, \chan: 0, 
			\in: (\ccNum: 1+(8*j)+i),
			\out: (\ccNum: 1+(8*j)+i), 
			\spec: \midiCC, \ioType: \inout)]
	}
	++
	[
		("btA"++(i+1)).asSymbol,(\midiType: \cc, \type: \midiBut, \chan: 0, \ccNum: 65+i, \spec: \midiCC, \ioType: \inout),
		("btB"++(i+1)).asSymbol,(\midiType: \cc, \type: \midiBut, \chan: 0, \ccNum: 73+i, \spec: \midiCC, \ioType: \inout),
		("knE"++(i+1)).asSymbol,(\midiType: \cc, \type: \encoder, \chan: 0, \ccNum: 81+i, \spec: \midiCC, \ioType: \inout),
		("knF"++(i+1)).asSymbol,(\midiType: \cc, \type: \encoder, \chan: 0, \ccNum: 89+i, \spec: \midiCC, \ioType: \inout),
		("knG"++(i+1)).asSymbol,(\midiType: \cc, \type: \encoder, \chan: 0, \ccNum: 97+i, \spec: \midiCC, \ioType: \inout)
	]
}.flat