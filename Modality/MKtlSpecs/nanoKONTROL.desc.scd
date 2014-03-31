// TODO - but_4_2_1 overwrites kn_1_3 !
// * fix - likely disable but 2 1 in scene 4, and leave kn 1 3 on.
// * check whether there are any other clashes of cc numbers !


//	// KORG nanoKONTROL specs:
//	// only cc messages,
//	// 4 hardware scenes, flattened out with underscores

/*
tests
MIDIMKtl.find;
m = MIDIMKtl('nnkn0');

// not working yet.
m.elementAt(\sl, 1, 1).addAction({ |mk| mk.value.post; "sl1 sc1 YO !".postln; });
m.elementAt(\sl, 1, 1).action_({ |mk| mk.value.round(0.01).post; "sl1 sc1 YO !".postln; });
m.elementAt(\sl, 2, 2).action_({ |mk| mk.value.round(0.01).post; "sl2 sc2 YO !".postln; });

m.elementAt(\kn, 1, 1).action_({ |mk| mk.value.round(0.01).post; "kn1 sc1 YO !".postln; });
m.elementAt(\kn, 2, 2).action_({ |mk| mk.value.round(0.01).post; "kn2 sc2 YO !".postln; });

m.elementAt(\but, 1, 1, 1).addAction({ |mk| mk.value.post; "but1 bt1 YO !".postln; });
m.elementAt(\but, 2, 2, 2).addAction({ |mk| mk.value.post; "sc2 chan2 bt2 YO !".postln; });


//test all:
MIDIMKtl('nnkn0').elementsDict.do{ |el| el.action_({ |v| "%: %".format( el.name, v.value ).postln }) }
*/

(

// the same in all scenes:
\rew:  (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 47, \spec: \midiBut, \mode: \push),
\play: (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 45, \spec: \midiBut, \mode: \push),
\fwd:  (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 48, \spec: \midiBut, \mode: \push),
\loop: (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 49, \spec: \midiBut, \mode: \push),
\stop: (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 46, \spec: \midiBut, \mode: \push),
\rec:  (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 44, \spec: \midiBut, \mode: \push),

\sl: [
	[ (2..6)++[8,9]++[12,13], 0 ! 9 ],
	[ [42,43]++(50..56),  0 ! 9 ],
	[ (85..93), 0 ! 9 ],
	[ 7 ! 9, (0..8) ]
].collect{ |page|
	page.flop.collect{ |xs|
		(\midiMsgType: \cc, \type: \slider, \midiChan: xs[1], \midiNum: xs[0], \spec: \midiCC)
	}
},

\kn: [
	[ (14..22), 0 ! 9 ],
	[ (57..66),  0 ! 9 ],
	[ (94..97)++(102..106), 0 ! 9 ],
	[ 10 ! 9, (0..8) ]
].collect{ |page|
	page.flop.collect{ |xs|
		(\midiMsgType: \cc, \type: \slider, \midiChan: xs[1], \midiNum: xs[0], \spec: \midiCC)
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
			(\midiMsgType: \cc, \type: \button, \midiChan: xs[1], \midiNum:  xs[0], \spec: \midiCC)
		}
	}
}

)
