//	// Teenage Engineering OP-1
//	// cc messages from four knobs,
// and lots of buttons (mostly with icons)

(
idInfo: "OP-1 Midi Device",
protocol: \midi,
deviceInfo: (
	vendorURI: "https://www.teenageengineering.com/products/op-1",
	// manualURI: "",
	description: "Full-featured synth which can also be used as a general-purpose controller.",
	features: [
		"2-octave keyboard witch transpose buttons",
		"4 encoders with hat-switch",
		"transport section",
		"20 buttons (1-4, 1-8 and special-purpose)",
	],
	notes: "Put the OP-1 into control-mode (<shift>-<COM>, then 2)",
	type: [\keyboard, \knob, \button],
	hasScribble: true
),
description: (
	\key: (
		\on: (5..124).collect{ |num|
			(\midiMsgType: \noteOn , \type: \key, \midiChan: 0, \midiNum: num, \spec: \midiNote, \ioType: \in)
		},
		\off: (5..124).collect{ |num|
			(\midiMsgType: \noteOff, \type: \key, \midiChan: 0, \midiNum: num, \spec: \midiNote, \ioType: \in)
		}
	),

	\kn: (
		\turn: [(1..4), [\blue, \green, \white, \red]].flop.collect { |desc, i|
			var num, label;
			#num, label = desc;
			(\midiMsgType: \cc, \type: \knob, \labels: [label], \midiChan: 0, \midiNum: num, \spec: \midiCC, \ioType: \in)
		},
		\hat:  [(64..67), [\blue, \green, \white, \red]].flop.collect { |desc, i|
			var num, label;
			#num, label = desc;
			(midiMsgType: \cc, type: \button, \labels: [label], \midiChan: 0, \midiNum: num, \spec: \midiBut, \mode: \push, \ioType: \in)
		}
	),
	\bt: (11..14).collect { |num|
		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: num, \spec: \midiBut, \ioType: \in)
	},
	\btPreset: [50, 51, 52, 21, 22, 23, 24, 25].collect { |num|
		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: num, \spec: \midiBut, \ioType: \in)
	},

	\btBubble: 	(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 5, \spec: \midiBut, \mode: \push, \ioType: \in),
	\btMetro: 	(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 6, \spec: \midiBut, \mode: \push, \ioType: \in),

	//
	\btSynth: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 7, \spec: \midiBut, \mode: \push, \ioType: \in),
	\btDrums: 	(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 8, \spec: \midiBut, \mode: \push, \ioType: \in),
	\btTape: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 9, \spec: \midiBut, \mode: \push, \ioType: \in),
	\btMix: 	(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 10, \spec: \midiBut, \mode: \push, \ioType: \in),


	// upper right
	\btSeq: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 26, \spec: \midiBut, \mode: \push, \ioType: \in),
	\btCom: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 49, \spec: \midiBut, \mode: \push, \ioType: \in),
	\btMic: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 48, \spec: \midiBut, \mode: \push, \ioType: \in),

	// red labels
	\btLift: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 15, \spec: \midiBut, \mode: \push, \ioType: \in),
	\btPaste: 	(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 16, \spec: \midiBut, \mode: \push, \ioType: \in),
	\btCut: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 17, \spec: \midiBut, \mode: \push, \ioType: \in),

	\btRec: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 38, \spec: \midiBut, \mode: \push, \ioType: \in),
	\btPlay: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 39, \spec: \midiBut, \mode: \push, \ioType: \in),
	\btStop: 		(\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 40, \spec: \midiBut, \mode: \push, \ioType: \in),

	'bend': 		('midiMsgType': 'bend', 'type': 'bender', 'midiChan': 0, 'midiNum':  0,'spec': 'midiBend', \ioType: \in)
)
)

/* test that this works:

MIDIMKtl.find;
m = MIDIMKtl('pmdd10');
m.verbose = true;

m.elementAt(\bt, 4).addAction({ |el| "but 4: %\n".postf(el.value); });
m.elementAt(\btJoin).action_({ |el| "btJoin: %\n".postf(el.value); });
m.elementAt(\keyOn, 1).action_({ |el| "keyOn: %\n".postf(el.value); });
m.elementAt(\keyOff, 1).action_({ |el| "keyOff: %\n".postf(el.value); });

m.elementAt(\kn, 1).action_({ |el| "el %: %\n".postf(el.name, el.value); });

*/
