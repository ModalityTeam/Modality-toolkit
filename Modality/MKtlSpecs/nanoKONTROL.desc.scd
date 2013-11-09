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

\scene:[
	(\sl:(2..9)++[12,13], \kn:(14..21), \buts: [(23..31),(33..41)] ),
	(\sl:[42,43]++(50..56), \kn:(57..66), \buts: [(67..75),(76..84)] ),
	(\sl:(85..93), \kn:(94..97)++(102..106), \buts: [(107..115),(116..124)] ),
].collect{ |env|
	(

		//row
		sl: env.sl.collect{ |i|

			(\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  i, \spec: \midiCC)

		},


		//row
		kn: env.kn.collect{ |i|

			(\midiType: \cc, \type: \knob, \midiChan: 0, \midiNum:  i, \spec: \midiCC)

		},


		//row column
		but: env.buts.collect{ |xs|
			xs.collect{ |num|

				(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum:  num, \spec: \midiCC)

			}
		}

	)
}++
[
(

	//row
	sl: (0..8).collect{ |i|

		(\midiType: \cc, \type: \slider, \midiChan: i, \midiNum:  7, \spec: \midiCC)

	},


	//row
	kn: (0..8).collect{ |i|

		(\midiType: \cc, \type: \knob, \midiChan: i, \midiNum:  10, \spec: \midiCC)

	},

	// doubled assignment with a knob in scene 1, assign channel 16 which is not used.
	//row column
	but: [[[16]++(1..8),(0..8)],[16,17]].flopWith{ |xs,ccNum|
		xs.collect{ |num|

			(\midiType: \cc, \type: \button, \midiChan: num, \midiNum:  ccNum, \spec: \midiCC)

		}
	}

)
]
)

