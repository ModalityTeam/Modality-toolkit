(
(
idInfo: "Livid Guitar Wing",
protocol: 'midi',
midiChan: 0,
'description': (
	//	noteOn 127 for start, cc for val, noteOff 0
	fader: [
		left: [
			noteOnOff: (midiNum: 1, spec: \midiNum, midiChan: 0),
			cc: (midiNum: 1, spec: \midiNum, midiChan: 0),
		],
		right: [
			noteOnOff: (midiNum: 2, spec: \midiNum, midiChan: 0),
			cc: (midiNum: 2, spec: \midiNum, midiChan: 0),
		],
		bottom: [
			noteOnOff: (midiNum: 3, spec: \midiNum, midiChan: 0),
			cc: (midiNum: 3, spec: \midiNum, midiChan: 0),
		]
	],
	// noteOn 64 noteOff 0, toggle
	tipPad: [noteOnOff: (midiNum: 4, mode: \toggle)],
	// noteOnOff, momentary
	pad: [
		index: (noteOnOff: (midiNum: 36, spec: \midiNum, midiChan: 0)),
		middle: (noteOnOff: (midiNum: 37, spec: \midiNum, midiChan: 0)),
		ring: (noteOnOff: (midiNum: 38, spec: \midiNum, midiChan: 0)),
		pinky: (noteOnOff: (midiNum: 39, spec: \midiNum, midiChan: 0)),
	],
	switch: [
		triDown: (noteOnOff: (midiNum: 40, spec: \midiNum, midiChan: 0)),
		triUp: (noteOnOff: (midiNum: 41, spec: \midiNum, midiChan: 0)),
		finger: [
			index: (noteOnOff: (midiNum: 42, spec: \midiNum, midiChan: 0)),
			middle: (noteOnOff: (midiNum: 43, spec: \midiNum, midiChan: 0)),
			ring: (noteOnOff: (midiNum: 44, spec: \midiNum, midiChan: 0)),
			pinky: (noteOnOff: (midiNum: 45, spec: \midiNum, midiChan: 0))
		],
		cutaway: [
			\1: (noteOnOff: (midiNum: 46, spec: \midiNum, midiChan: 0)),
			\2: (noteOnOff: (midiNum: 47, spec: \midiNum, midiChan: 0)),
			\3: (noteOnOff: (midiNum: 48, spec: \midiNum, midiChan: 0)),
			\4: (noteOnOff: (midiNum: 49, spec: \midiNum, midiChan: 0))
		],
		accel: [
			x: (cc: (midiNum: 5, spec: \midiNum, midiChan: 0)),
			y: (cc: (midiNum: 6, spec: \midiNum, midiChan: 0)),
			z: (cc: (midiNum: 7, spec: \midiNum, midiChan: 0)),
		]
	]
)
)
);