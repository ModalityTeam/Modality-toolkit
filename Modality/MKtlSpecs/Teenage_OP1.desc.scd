//	// Teenage Engineering OP-1
//	// cc messages from four knobs,
// and lots of buttons (mostly with icons)
// knob hat presses missing!

/* test that is works:

MIDIMKtl.find;
m = MIDIMKtl('pmdd10');
m.verbose = true;

m.elementAt(\but, 4).addAction({ |el| "but 4: %\n".postf(el.value); });
m.elementAt(\btJoin).action_({ |el| "btJoin: %\n".postf(el.value); });
m.elementAt(\keyOn, 1).action_({ |el| "keyOn: %\n".postf(el.value); });
m.elementAt(\keyOff, 1).action_({ |el| "keyOff: %\n".postf(el.value); });

m.elementAt(\kn, 1).action_({ |el| "el %: %\n".postf(el.name, el.value); });

*/
(

keyOn: (29..83).collect{|padNum| (\midiMsgType: \noteOn, \type: \key, midiChan: 0,
		\midiNum: padNum, \spec: \midiNote)
},
\keyOff: (29..83).collect{|padNum| (\midiMsgType: \noteOff, \type: \key, midiChan: 0,
		\midiNum: padNum, \spec: \midiNote)
},

\kn: (1..4).collect { |num|
	(\midiMsgType: \cc, \type: \knob, \midiChan: 0, \midiNum: num, \spec: \midiCC)
},

\btBubble: 	(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 5, \spec: \midiBut, \mode: \push),
\btMetro: 	(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 6, \spec: \midiBut, \mode: \push),

\btWave: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 7, \spec: \midiBut, \mode: \push),
\btCircle: 	(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 8, \spec: \midiBut, \mode: \push),
\btTape: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 9, \spec: \midiBut, \mode: \push),
\btLevels: 	(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 10, \spec: \midiBut, \mode: \push),

\but: (11..14).collect { |num|
	(\midiMsgType: \cc, \type: \knob, \midiChan: 0, \midiNum: num, \spec: \midiBut)
},
\butsm: [50, 51, 52, 21, 22, 23, 24, 25].collect { |num|
	(\midiMsgType: \cc, \type: \knob, \midiChan: 0, \midiNum: num, \spec: \midiBut)
},

\btDots: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 26, \spec: \midiBut, \mode: \push),
\btCom: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 49, \spec: \midiBut, \mode: \push),
\btSlot: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 48, \spec: \midiBut, \mode: \push),

\but: (11..14).collect { |num|
	(\midiMsgType: \cc, \type: \knob, \midiChan: 0, \midiNum: num, \spec: \midiBut)
},

\btArrUp: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 15, \spec: \midiBut, \mode: \push),
\btArrDown: 	(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 16, \spec: \midiBut, \mode: \push),
\btJoin: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 17, \spec: \midiBut, \mode: \push),

\btRec: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 38, \spec: \midiBut, \mode: \push),
\btPlay: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 39, \spec: \midiBut, \mode: \push),
\btStop: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 40, \spec: \midiBut, \mode: \push),

'bend': 		('midiMsgType': 'bend', 'type': 'bender', 'midiChan': 0, 'midiNum':  0,'spec': 'midiBend')
)
