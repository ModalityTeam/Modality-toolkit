//	// KORG nanoKONTROL specs:
//	// only cc messages,
//	// 4 hardware scenes, flattened out with underscores

(

// the same in all scenes:
\rew:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 47, \spec: \midiBut, \mode: \push),
\play: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 45, \spec: \midiBut, \mode: \push),
\fwd:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 48, \spec: \midiBut, \mode: \push),
\loop: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 49, \spec: \midiBut, \mode: \push),
\stop: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 46, \spec: \midiBut, \mode: \push),
\rec:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 44, \spec: \midiBut, \mode: \push),

\sl: [
	[ (2..9)++[12,13], 0 ! 9 ],
	[ [42,43]++(50..56),  0 ! 9 ],
	[ (85..93), 0 ! 9 ],
	[ 7 ! 9, (0..8) ]
].collect{ |page|
	page.flop.collect{ |xs|
		(\midiType: \cc, \type: \slider, \midiChan: xs[1], \midiNum: xs[0].postln, \spec: \midiCC)
	}
},

\kn: [
	[ (14..21), 0 ! 9 ],
	[ (57..66),  0 ! 9 ],
	[ (94..97)++(102..106), 0 ! 9 ],
	[ 10 ! 9, (0..8) ]
].collect{ |page|
	page.flop.collect{ |xs|
		(\midiType: \cc, \type: \slider, \midiChan: xs[1].postln, \midiNum: xs[0].postln, \spec: \midiCC)
	}
},

\but: [
	[ [(23..31), 0 ! 9 ], [(33..41), 0 ! 9 ]],
	[ [(67..75), 0 ! 9 ], [(76..84), 0 ! 9 ]],
	[ [(107..115), 0 ! 9 ], [(116..124), 0 ! 9 ]],
	[ [16 ! 9, [16]++(1..8)], [ 17 ! 9, (0..8) ]]
].collect{ |page|
	page.collect{ |row|
		row.flop.collect{ |xs|
			(\midiType: \cc, \type: \button, \midiChan: xs[1], \midiNum:  xs[0].postln, \spec: \midiCC)
		}
	}
}

)

