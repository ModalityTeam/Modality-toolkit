// Novation Launchpad specs: 
// Mostly NoteOn / NoteOff, some cc messages, 
// no hardware scenes, flattened out with underscores

[

	\up:      (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 104, \spec: \midiBut, \mode: \push),
	\down:    (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 105, \spec: \midiBut, \mode: \push),
	\left:    (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 106, \spec: \midiBut, \mode: \push),
	\right:   (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 107, \spec: \midiBut, \mode: \push),
	\session: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 108, \spec: \midiBut, \mode: \push),
	\user1:   (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 109, \spec: \midiBut, \mode: \push),
	\user2:   (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 110, \spec: \midiBut, \mode: \push),
	\mixer:   (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 111, \spec: \midiBut, \mode: \push),

]
++ 
((0, 16 .. 112) +.t (0..7)).flat.collect{|num, i|
	[("bu"++i).asSymbol, (\midiType: \note, \type: \button, \chan: 0, \midiNote: num, \spec: \midiBut, \mode: \push)]
}.flat
++
((0, 16 .. 112) + 8).flat.collect{|num, i|
	[("ar"++i).asSymbol, (\midiType: \note, \type: \button, \chan: 0, \midiNote: num, \spec: \midiBut, \mode: \push)]
}.flat
