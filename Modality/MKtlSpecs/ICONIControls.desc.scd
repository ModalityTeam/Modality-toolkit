
//MIDIMKtl('cncn2000').elements.do{ |el| el.action_{ el.name.postln} }

(

[
	[ 16, 17, 18, 19, 20, 21, 22, 23, 48 ],
	[ 8, 9, 10, 11, 12, 13, 14, 15, 49 ]
].collect{ |xs, row|

	xs.collect{ |note, column|

		["but_%_%".format(row+1,column+1).asSymbol, (\midiType: \note, \type: \button, \midiChan: 0, \midiNum:  note, \spec: \midiVel)]
	}
}++
[
	[ 91, 94, 92 ],
	[ 86, 93, 95 ]
].collect{ |xs, row|

	xs.collect{ |note, column|

		["leftbut_%_%".format(row+1,column+1).asSymbol, (\midiType: \note, \type: \button, \midiChan: 0, \midiNum:  note, \spec: \midiVel)]

	}
}++
(0..8).collect{ |i, n|
	["sl_%".format(n+1).asSymbol, (\midiType: \cc, \type: \slider, \midiChan: i, \midiNum:  13, \spec: \midiCC)]
}++
((16..23)++[12]).collect{ |i, n|
	["kn_%".format(n+1).asSymbol, (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  i, \spec: \midiCC)]
}

).flat