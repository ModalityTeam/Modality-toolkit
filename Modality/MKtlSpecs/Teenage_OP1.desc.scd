//	// Teenage Engineering OP-1 
//	// cc messages from four knobs, 
	// and lots of buttons (mostly with icons)
	// knob hat presses missing!

[
	\kn_1: (\midiType: \cc, \type: \knob, \midiChan: 0, \midiNum: 1, \spec: \midiCC),
	\kn_2: (\midiType: \cc, \type: \knob, \midiChan: 0, \midiNum: 2, \spec: \midiCC),
	\kn_3: (\midiType: \cc, \type: \knob, \midiChan: 0, \midiNum: 3, \spec: \midiCC),
	\kn_4: (\midiType: \cc, \type: \knob, \midiChan: 0, \midiNum: 4, \spec: \midiCC),


	\btBubble: 	(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 5, \spec: \midiBut, \mode: \push),
	\btMetro: 	(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 6, \spec: \midiBut, \mode: \push),
	\btWave: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 7, \spec: \midiBut, \mode: \push),
	\btCircle: 	(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 8, \spec: \midiBut, \mode: \push),
	\btTape: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 9, \spec: \midiBut, \mode: \push),
	\btLevels: 	(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 10, \spec: \midiBut, \mode: \push),
	
	\bt_1: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 11, \spec: \midiBut, \mode: \push),
	\bt_2: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 12, \spec: \midiBut, \mode: \push),
	\bt_3: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 13, \spec: \midiBut, \mode: \push),
	\bt_4: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 14, \spec: \midiBut, \mode: \push),

	\btsm_1: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 50, \spec: \midiBut, \mode: \push),
	\btsm_2: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 51, \spec: \midiBut, \mode: \push),
	\btsm_3: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 52, \spec: \midiBut, \mode: \push),
	\btsm_4: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 21, \spec: \midiBut, \mode: \push),
	\btsm_5: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 22, \spec: \midiBut, \mode: \push),
	\btsm_6: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 23, \spec: \midiBut, \mode: \push),
	\btsm_7: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 24, \spec: \midiBut, \mode: \push),
	\btsm_8: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 25, \spec: \midiBut, \mode: \push),
	
	\btDots: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 26, \spec: \midiBut, \mode: \push),
	\btCom: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 49, \spec: \midiBut, \mode: \push),
	\btSlot: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 48, \spec: \midiBut, \mode: \push),
	\btRec: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 38, \spec: \midiBut, \mode: \push),
	\btPlay: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 39, \spec: \midiBut, \mode: \push),
	\btStop: 		(\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 40, \spec: \midiBut, \mode: \push),
	
		// suggestion: global responders for all note keys
	\noteOn: 		(\midiType: \note, \type: \keys, \midiChan: 0, \noteNum: (29..64), \spec: \midiVel, \mode: \key),
	\noteOff: 		(\midiType: \note, \type: \keys, \midiChan: 0, \noteNum: (29..64), \spec: \midiVel, \mode: \key)
]
