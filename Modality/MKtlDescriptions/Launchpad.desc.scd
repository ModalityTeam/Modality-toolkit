// Novation Launchpad specs:
// Mostly NoteOn / NoteOff, some cc messages,
// no hardware scenes, flattened out with underscores

(
device: "Launchpad",
protocol: \midi,
description: (
	\up:      (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 104, \spec: \midiBut, \mode: \push),
	\down:    (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 105, \spec: \midiBut, \mode: \push),
	\left:    (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 106, \spec: \midiBut, \mode: \push),
	\right:   (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 107, \spec: \midiBut, \mode: \push),
	\session: (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 108, \spec: \midiBut, \mode: \push),
	\user1:   (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 109, \spec: \midiBut, \mode: \push),
	\user2:   (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 110, \spec: \midiBut, \mode: \push),
	\mixer:   (\midiMsgType: \cc, \type: \button, \midiChan: 0, \midiNum: 111, \spec: \midiBut, \mode: \push),

	\padOn: ((0, 16 .. 112) +.t (0..7)).flat.collect{|num, i|
		(\midiMsgType: \noteOn, \type: \pad, \midiChan: 0, \midiNum: num, \spec: \midiVel)
	},
	\padOff: ((0, 16 .. 112) +.t (0..7)).flat.collect{|num, i|
		(\midiMsgType: \noteOff, \type: \pad, \midiChan: 0, \midiNum: num, \spec: \midiVel)
	},

	\arrOn: ((0, 16 .. 112) + 8).flat.collect{|num, i|
		(\midiMsgType: \noteOn, \type: \pad, \midiChan: 0, \midiNum: num, \spec: \midiVel)
	},
	\arrOff: ((0, 16 .. 112) + 8).flat.collect{|num, i|
		(\midiMsgType: \noteOff, \type: \pad, \midiChan: 0, \midiNum: num, \spec: \midiVel)
	}
)
)

