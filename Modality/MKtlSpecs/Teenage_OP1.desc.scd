//	// Teenage Engineering OP-1 
//	// cc messages from four knobs, 
	// and lots of buttons (mostly with icons)
	// knob hat presses missing!

[
	\kn_1: (\midiType: \cc, \type: \knob, \chan: 0, \ccNum: 1, \spec: \midiCC),
	\kn_2: (\midiType: \cc, \type: \knob, \chan: 0, \ccNum: 2, \spec: \midiCC),
	\kn_3: (\midiType: \cc, \type: \knob, \chan: 0, \ccNum: 3, \spec: \midiCC),
	\kn_4: (\midiType: \cc, \type: \knob, \chan: 0, \ccNum: 4, \spec: \midiCC),


	\btBubble: 	(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 5, \spec: \midiBut, \mode: \push),
	\btMetro: 	(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 6, \spec: \midiBut, \mode: \push),
	\btWave: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 7, \spec: \midiBut, \mode: \push),
	\btCircle: 	(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 8, \spec: \midiBut, \mode: \push),
	\btTape: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 9, \spec: \midiBut, \mode: \push),
	\btLevels: 	(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 10, \spec: \midiBut, \mode: \push),
	
	\bt_1: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 11, \spec: \midiBut, \mode: \push),
	\bt_2: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 12, \spec: \midiBut, \mode: \push),
	\bt_3: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 13, \spec: \midiBut, \mode: \push),
	\bt_4: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 14, \spec: \midiBut, \mode: \push),

	\btsm_1: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 50, \spec: \midiBut, \mode: \push),
	\btsm_2: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 51, \spec: \midiBut, \mode: \push),
	\btsm_3: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 52, \spec: \midiBut, \mode: \push),
	\btsm_4: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 21, \spec: \midiBut, \mode: \push),
	\btsm_5: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 22, \spec: \midiBut, \mode: \push),
	\btsm_6: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 23, \spec: \midiBut, \mode: \push),
	\btsm_7: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 24, \spec: \midiBut, \mode: \push),
	\btsm_8: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 25, \spec: \midiBut, \mode: \push),
	
	\btDots: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 26, \spec: \midiBut, \mode: \push),
	\btCom: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 49, \spec: \midiBut, \mode: \push),
	\btSlot: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 48, \spec: \midiBut, \mode: \push),
	\btRec: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 38, \spec: \midiBut, \mode: \push),
	\btPlay: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 39, \spec: \midiBut, \mode: \push),
	\btStop: 		(\midiType: \cc, \type: \button, \chan: 0, \ccNum: 40, \spec: \midiBut, \mode: \push),
	
		// suggestion: global responders for all note keys
	\noteOn: 		(\midiType: \note, \type: \keys, \chan: 0, \noteNum: (29..64), \spec: \midiVel, \mode: \key),
	\noteOff: 		(\midiType: \note, \type: \keys, \chan: 0, \noteNum: (29..64), \spec: \midiVel, \mode: \key)
]
