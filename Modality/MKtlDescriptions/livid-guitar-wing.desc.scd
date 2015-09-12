(
(
deviceName: "Livid Guitar Wing",
protocol: 'midi',
deviceType: \multiController,
elementTypes: [\button, \touchFader, \pad],
status: "tested",

idInfo: "Livid Guitar Wing",


deviceInfo: (
	vendorURI: "http://lividinstruments.com/products/guitar-wing/",
	manualURI: "http://lividinstruments.com/support/",
	description: "controller for guitar",
	features: [],
	notes: "_none_",
	hasScribble: true
),

'description': (
	//	noteOn 127 for start, cc for val, noteOff 0
	fader: [
		left: [
			noteOnOff: (type: \touchFader, midiNum: 1, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff),
			cc: (type: \touchFader, midiNum: 1, spec: \midiNum, midiChan: 0, midiMsgType: \control),
		],
		right: [
			noteOnOff: (type: \touchFader, midiNum: 2, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff),
			cc: (type: \touchFader, midiNum: 2, spec: \midiNum, midiChan: 0, midiMsgType: \control),
		],
		bottom: [
			noteOnOff: (type: \touchFader, midiNum: 3, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff),
			cc: (type: \touchFader, midiNum: 3, spec: \midiNum, midiChan: 0, midiMsgType: \control),
		]
	],
	// noteOn 64 noteOff 0, toggle
	tipPad: (type: \pad, midiNum: 4, mode: \toggle, \spec: \midiNum, midiMsgType: \noteOnOff),

	// noteOnOff, momentary
	pad: [
		index: (type: \pad, midiNum: 36, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff),
		middle: (type: \pad, midiNum: 37, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff),
		ring: (type: \pad, midiNum: 38, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff),
		pinky: (type: \pad, midiNum: 39, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff),
	],
	switch: [
		triDown: (type: \touchButton, midiNum: 40, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff),
		triUp: (type: \touchButton, midiNum: 41, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff),
		finger: [
			index: (type: \touchButton, midiNum: 42, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff),
			middle: (type: \touchButton, midiNum: 43, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff),
			ring: (type: \touchButton, midiNum: 44, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff),
			pinky: (type: \touchButton, midiNum: 45, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff)
		],
		cutaway: [
			\1: (type: \switch, nmidiNum: 46, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff),
			\2: (type: \switch, midiNum: 47, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff),
			\3: (type: \switch, midiNum: 48, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff),
			\4: (type: \switch, midiNum: 49, spec: \midiNum, midiChan: 0, midiMsgType: \noteOnOff)
		],
		accel: [
			x: (type: \accelAxis, midiNum: 5, spec: \midiNum, midiChan: 0, midiMsgType: \control),
			y: (type: \accelAxis, midiNum: 6, spec: \midiNum, midiChan: 0, midiMsgType: \control),
			z: (type: \accelAxis, midiNum: 7, spec: \midiNum, midiChan: 0, midiMsgType: \control)
		]
	]
)
)
);