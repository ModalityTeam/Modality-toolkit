(
(
deviceName: "Livid Guitar Wing",
protocol: 'midi',
deviceType: \multiController,
elementTypes: [\button, \touchFader, \pad],
status: (
	linux: "unknown",
	osx: "partly working, sends more data than in manual",
	win: "unknown"),

idInfo: "Livid Guitar Wing",


deviceInfo: (
	vendorURI: "http://lividinstruments.com/products/guitar-wing/",
	manualURI: "http://lividinstruments.com/support/",
	description: "controller for guitar",
	features: [],
	notes: "_none_",
	hasScribble: true
),

'elementsDesc': (
		//	noteOn 127 for start, cc for val, noteOff 0
	elements: [
		(
			key: \fader,
			shared: (type: \touchFader, spec: \midiCC, midiChan: 0),
			elements: [
				[\left, 1],
				[\right, 2],
				[\bottom, 3]
			].collect { |pair, i|
					var name, num; #name, num = pair;
				(
					key: name,
					shared: (midiNum: num),
					elements: [
						(key: \touch, midiMsgType: \noteOnOff),
						(key: \pos,   midiMsgType: \control)
					]
				)
			}
		),
		// noteOn 64 noteOff 0, toggle
		(
			key: \tipPad,
			type: \pad, midiNum: 4, mode: \toggle,
			\spec: \midiCC, midiMsgType: \noteOnOff
		),

		// noteOnOff, momentary
		(
			key: \pad,
			shared: (elementType: \touchButton, spec: \midiCC,
				midiChan: 0, midiMsgType: \noteOnOff),
			elements: [
				(key: \index, midiNum: 36),
				(key: \middle, midiNum: 37),
				(key: \ring, midiNum: 38),
				(key: \pinky, midiNum: 39),
			]
		),
		(
			key: \switch,
			shared: (type: \touchButton, spec: \midiCC, midiChan: 0,
				midiMsgType: \noteOnOff),
			elements: [
				(key: \triDown,  midiNum: 40),
				(key: \triUp,  midiNum: 41),
				(
					key: \finger,
					elements: [
						(key: \index,  midiNum: 42),
						(key: \middle,  midiNum: 43),
						(key: \ring,  midiNum: 44),
						(key: \pinky,  midiNum: 45),
					]
				)
			]
		),
		(
			key: \cutaway,
			shared: (type: \switch, spec: \midiCC, midiChan: 0,
				midiMsgType: \noteOnOff),
			elements: [
				(key: \1, midiNum: 46),
				(key: \2, midiNum: 47),
				(key: \3, midiNum: 48),
				(key: \4, midiNum: 49)
			]
		),
		(
			key: \accel,
			shared: (type: \accelAxis, spec: \midiCC, midiChan: 0, midiMsgType: \control),
			elements: [
				(key: \x, midiNum: 5),
				(key: \y, midiNum: 6),
				(key: \z, midiNum: 7)
			]
		)
	]
)
)
);