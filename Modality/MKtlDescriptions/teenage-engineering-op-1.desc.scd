//	// Teenage Engineering OP-1
//	// cc messages from four knobs,
// and lots of buttons (mostly with icons)

/* test that this works:

MKtl.find;
m = MKtl('op1', "teenage-engineering-op-1");
m.trace;
m.gui;
m.elAt(\bt, \4).addAction({ |el| "but 4: %\n".postf(el.value); });
m.elAt(\btBubble).action_({ |el| "btBubble: %\n".postf(el.value); });
m.elAt(\key, 0).action_({ |el| "keyOn: %\n".postf(el.value); });
m.elAt(\key, 0).action_({ |el| "keyOff: %\n".postf(el.value); });

m.elementAt(\kn, 0).action_({ |el| "el %: %\n".postf(el.name, el.value); });

*/

(
deviceName: "OP-1 Midi Device",
protocol: \midi,
deviceType: \midiKeyboard,
elementTypes: [\pianoKey, \knob, \button],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "OP-1 Midi Device",

deviceInfo: (
	vendorURI: "https://www.teenageengineering.com/products/op-1",
	// manualURI: "",
	description: "Full-featured synth which can also be used as a general-purpose controller.",
	features: [
		"2-octave midiKeyboard witch transpose buttons",
		"4 encoders with hat-switch",
		"transport section",
		"20 buttons (1-4, 1-8 and special-purpose)",
	],
	notes: "Put the OP-1 into control-mode (<shift>-<COM>, then 2)",

	hasScribble: true
),
elementsDesc: (
	elements: [
		(

			key: \key,
			shared:  (\elementType: \key,
				\midiChan: 0, \spec: \midiVel, \ioType: \in),
			elements: (0..124).collect { |num, i| (
				shared: (midiNum: num),
				elements: [
						(key: \on,  midiMsgType: \noteOn ),
						(key: \off, midiMsgType: \noteOff)
				]
			)}

			// // shared noteOnOff implementation, not working 'cause velocity of noteOff != 0
			// key: \key,
			// shared: (\midiMsgType: \noteOnOff, \elementType: \key,
			// \midiChan: 0, \spec: \midiVel, \ioType: \in),
			// elements: (5..124).collect { |num| (midiNum: num) }


		),
		(
			key: \kn,
			elements: [
				(
					key: \turn,
					shared: (\midiMsgType: \cc, \type: \knob, \midiChan: 0,
						\spec: \midiCC, \ioType: \in),
					elements: [(1..4), [\blue, \green, \white, \red]].flop
					.collect { |desc, i|
						var num, label;
						#num, label = desc;
						(\midiNum: num, \labels: [label])
					}
				),
				(
					key: \hat,
					shared: (midiMsgType: \cc, type: \button, \midiChan: 0,
						\spec: \midiBut, \mode: \push, \ioType: \in),
					elements: [(64..67), [\blue, \green, \white, \red]].flop
					.collect { |desc, i|
						var num, label;
						#num, label = desc;
						(\midiNum: num, \labels: [label])
					}
				)
			]
		),
		(
			key: \bt,
			shared: (\midiMsgType: \cc, \type: \button, \midiChan: 0,
				\spec: \midiBut, \ioType: \in),
			elements: (11..14).collect { |num| (\midiNum: num) },
		),
		(
			key: \btPreset,
			shared: (\midiMsgType: \cc, \type: \button, \midiChan: 0,
				\spec: \midiBut, \ioType: \in),
			elements: [50, 51, 52, 21, 22, 23, 24, 25].collect { |num|
				(midiNum: num)
			}
		),
		(
			key: \btBubble,
			\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 5,
			\spec: \midiBut, \mode: \push, \ioType: \in),
		(
			key: \btMetro,
			\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 6,
			\spec: \midiBut, \mode: \push, \ioType: \in),
		(
			key: \btSynth,
			\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 7,
			\spec: \midiBut, \mode: \push, \ioType: \in),
		(
			key: \btDrums,
			\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 8,
			\spec: \midiBut, \mode: \push, \ioType: \in),
		(
			key: \btTape, \midiNum: 9, \midiMsgType: \cc, \type: \button,
			\midiChan: 0, \spec: \midiBut, \mode: \push, \ioType: \in),
		(
			key: \btMix, \midiNum: 10, \midiMsgType: \cc, \type: \button,
			\midiChan: 0, \spec: \midiBut, \mode: \push, \ioType: \in),

		// upper right
		(
			key: \btSeq,
			\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 26,
			\spec: \midiBut, \mode: \push, \ioType: \in),
		(
			key: \btCom,
			\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 49,
			\spec: \midiBut, \mode: \push, \ioType: \in),
		(
			key: \btMic,
			\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 48,
			\spec: \midiBut, \mode: \push, \ioType: \in),
		// red labels
		(
			key: \btLift,
			\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 15,
			\spec: \midiBut, \mode: \push, \ioType: \in),
		(
			key: \btPaste,
			\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 16, \spec: \midiBut, \mode: \push, \ioType: \in),

		(
			key: \btCut,
			\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 17,
			\spec: \midiBut, \mode: \push, \ioType: \in),
		(
			key: \btRec,
			\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 38,
			\spec: \midiBut, \mode: \push, \ioType: \in),
		(
			key: \btPlay,
			\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 39,
			\spec: \midiBut, \mode: \push, \ioType: \in),
		(
			key: \btStop,
			\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 40,
			\spec: \midiBut, \mode: \push, \ioType: \in),
		(
			key: 'bend',
			'midiMsgType': 'bend', 'type': 'bender', 'midiChan': 0, 'midiNum':  0,
			'spec': 'midiBend', \ioType: \in)
	]
)
)
