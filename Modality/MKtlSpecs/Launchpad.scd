// Novation Launchpad specs: 
// Mostly NoteOn / NoteOff, some cc messages, 
// no hardware scenes, flattened out with underscores

[

	\up:      (\msgType: \cc, \type: \button, \chan: 0, \ccNum: 104, \spec: \midiBut, \mode: \push),
	\down:    (\msgType: \cc, \type: \button, \chan: 0, \ccNum: 105, \spec: \midiBut, \mode: \push),
	\left:    (\msgType: \cc, \type: \button, \chan: 0, \ccNum: 106, \spec: \midiBut, \mode: \push),
	\right:   (\msgType: \cc, \type: \button, \chan: 0, \ccNum: 107, \spec: \midiBut, \mode: \push),
	\session: (\msgType: \cc, \type: \button, \chan: 0, \ccNum: 108, \spec: \midiBut, \mode: \push),
	\user1:   (\msgType: \cc, \type: \button, \chan: 0, \ccNum: 109, \spec: \midiBut, \mode: \push),
	\user2:   (\msgType: \cc, \type: \button, \chan: 0, \ccNum: 110, \spec: \midiBut, \mode: \push),
	\mixer:   (\msgType: \cc, \type: \button, \chan: 0, \ccNum: 111, \spec: \midiBut, \mode: \push),

]
++ 
((0, 16 .. 112) +.t (0..7)).flat.collect{|num, i|
	[("bu"++i).asSymbol, (\msgType: \note, \type: \button, \chan: 0, \ccNum: num, \spec: \midiBut, \mode: \push)]
}.flat
++
((0, 16 .. 112) + 8).flat.collect{|num, i|
	[("ar"++i).asSymbol, (\msgType: \note, \type: \button, \chan: 0, \ccNum: num, \spec: \midiBut, \mode: \push)]
}.flat
