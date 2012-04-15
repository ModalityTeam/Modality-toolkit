// preset 3

([105, 106, 107, 108, 110, 111, 112, 116, 26].collect {|num, i|
	[("sl_" ++ i).asSymbol, (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: num, \spec: \midiCC, \ioType: \in)]
} ++

[45, 46, 47, 5, 80, 81, 82, 83].collect {|num, i|
	[("kn1_" ++ i).asSymbol, (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: num, \spec: \midiCC, \ioType: \in)]
} ++

[50, 51, 55, 87, 75, 76, 77, 78].collect {|num, i|
	[("kn2_" ++ i).asSymbol, (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: num, \spec: \midiCC, \ioType: \in)]
} ++

[20, 21, 40, 43, 70, 71, 72, 73].collect {|num, i|
	[("kn3_" ++ i).asSymbol, (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: num, \spec: \midiCC, \ioType: \in)]
} ++

[57, 52, 53, 54, 41, 42, 44, 22, 23, 24].collect {|num, i|
	[("But_" ++ i).asSymbol, (\midiType: \cc, \type: \button, \chan: 0, \ccNum: num, \spec: \midiBut, \mode: \toggle, \ioType: \in)]
}

).flat