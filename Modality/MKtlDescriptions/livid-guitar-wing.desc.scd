(
(
idInfo: "Livid Guitar Wing",
protocol: 'midi',
midiChan: 0,
'description': (
	//	noteOn 127 for start, cc for val, noteOff 0
	fader: [
		left: [
			noteOnOff: (midiNum: 1, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff),
			cc: (midiNum: 1, spec: \midiNum, midiChan: 0, midiMsgType: \control),
		],
		right: [
			noteOnOff: (midiNum: 2, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff),
			cc: (midiNum: 2, spec: \midiNum, midiChan: 0, midiMsgType: \control),
		],
		bottom: [
			noteOnOff: (midiNum: 3, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff),
			cc: (midiNum: 3, spec: \midiNum, midiChan: 0, midiMsgType: \control),
		]
	],
	// noteOn 64 noteOff 0, toggle
	tipPad: (midiNum: 4, mode: \toggle, \spec: \midiNum, midiMsgType: \noteOnOff),

	// noteOnOff, momentary
	pad: [
		index: (noteOnOff: (midiNum: 36, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff)),
		middle: (noteOnOff: (midiNum: 37, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff)),
		ring: (noteOnOff: (midiNum: 38, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff)),
		pinky: (noteOnOff: (midiNum: 39, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff)),
	],
	switch: [
		triDown: (noteOnOff: (midiNum: 40, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff)),
		triUp: (noteOnOff: (midiNum: 41, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff)),
		finger: [
			index: (noteOnOff: (midiNum: 42, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff)),
			middle: (noteOnOff: (midiNum: 43, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff)),
			ring: (noteOnOff: (midiNum: 44, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff)),
			pinky: (noteOnOff: (midiNum: 45, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff))
		],
		cutaway: [
			\1: (noteOnOff: (midiNum: 46, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff)),
			\2: (noteOnOff: (midiNum: 47, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff)),
			\3: (noteOnOff: (midiNum: 48, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff)),
			\4: (noteOnOff: (midiNum: 49, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff))
		],
		accel: [
			x: (cc: (midiNum: 5, spec: \midiNum, midiChan: 0, midiMsgType: \control)),
			y: (cc: (midiNum: 6, spec: \midiNum, midiChan: 0, midiMsgType: \control)),
			z: (cc: (midiNum: 7, spec: \midiNum, midiChan: 0, midiMsgType: \control)),
		]
	]
)
)
);