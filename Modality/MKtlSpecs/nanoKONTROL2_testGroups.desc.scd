//	// KORG nanoKONTROL2 specs: 
//	// test creating groups automatically,
//	// so collect over sliders etc becoes easy
	// automatically keep everything flat
	// just add groups on top as sugar
	// grids and scenes by indexes

[
	\rew:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 43, \spec: \midiBut, \mode: \push),
	\fwd:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 44, \spec: \midiBut, \mode: \push),
	\stop: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 42, \spec: \midiBut, \mode: \push),
	\play: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 41, \spec: \midiBut, \mode: \push),
	\rec:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 45, \spec: \midiBut, \mode: \push),
	\cycle: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 46, \spec: \midiBut, \mode: \push),
	\mset: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 60, \spec: \midiBut, \mode: \push),
	\mleft: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 61, \spec: \midiBut, \mode: \push),
	\mright: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 62, \spec: \midiBut, \mode: \push),
	\tleft: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 58, \spec: \midiBut, \mode: \push),
	\tright: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 59, \spec: \midiBut, \mode: \push),


	\sl: (\midiType: \cc, \type: \slider, index: [1, 2, 3, 4, 5, 6, 7, 8], \midiChan: 0, \midiNum:  [0, 1, 2, 3, 4, 5, 6, 7], \spec: \midiCC),
	\kn: (\midiType: \cc, \type: \knob, index: [1, 2, 3, 4, 5, 6, 7, 8], \midiChan: 0, \midiNum:  [16, 17, 18, 19, 20, 21, 22, 23], \spec: \midiCC), 

	\br: (\midiType: \cc, \type: \button, \midiChan: 0, index: (1..8), \midiNum: (64..71), \spec: \midiBut, \mode: \push),
	\bm: (\midiType: \cc, \type: \button, \midiChan: 0, index: (1..8), \midiNum: (48..55), \spec: \midiBut, \mode: \push),
	\br: (\midiType: \cc, \type: \button, \midiChan: 0, index: (1..8), \midiNum: (64..71), \spec: \midiBut, \mode: \push),	\bs: (\midiType: \cc, \type: \button, \midiChan: 0, index: (1..8), \midiNum: (32..39), \spec: \midiBut, \mode: \push)	
]

/* 

creates:

sl1: ..
sl2: ... 

kn1: ..
kn2: ..


m.groups[\sl]	// this is
(1: same MKtlElement as \sl1, 
 2: same MKtlElement as \sl2, 
); 

m.groups[\sl]	// this is
(1: same MKtlElement as \sl1, 
 2: same MKtlElement as \sl2, 
); 

	// 
m.groups.put(\mygroup, (
	\otto: MKtlElement \sl1, 
	\carl, MKtlElement \bu1, 
));

*/