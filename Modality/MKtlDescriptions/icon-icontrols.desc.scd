
//MIDIMKtl('cncn2000').elements.do { |el| el.action_{ el.name.postln} }

(
deviceName: "iCON iControls V2.00",
protocol: \midi,
deviceType: \faderbox,
elementTypes: [\fader],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "iCON iControls V2.00",

deviceInfo: (
	vendorURI: "http://www.icon-global.com/Controllers_MIDI+recording+controllers_iControls+.htm",
	manualURI: "http://www.icon-global.com/download%5Cuser%20manual%5CIC%20PD3V1.00-E.zip",
	// description: "",
	// features: [],
	// notes: "",

	// hasScribble: false
),
elementsDesc: (
	elements: [
		(
			key: \bt,
			shared: (midiMsgType: \noteOnOff, elementType: \button,
				midiChan: 0, spec: \midiVel),
			elements: #[
				[ 16, 17, 18, 19, 20, 21, 22, 23, 48 ],
				[  8,  9, 10, 11, 12, 13, 14, 15, 49 ]
			].collect { |xs, row|
				(elements: xs.collect { |note, col| (midiNum: note) })
			}
		),
		(
			key: \sl,
			shared: (midiMsgType: \cc, elementType: \slider,
				midiNum:  13, spec: \midiCC),
			elements: (0..8).collect { |i, n| (midiChan: i) }
		),
		(
			key: \kn,
			shared: (midiMsgType: \cc, elementType: \slider,
				midiChan: 0, spec: \midiCC),
			elements: ((16..23)++[12]).collect { |i, n| (midiNum: i) }
		),
		(
			key: \tr,
			shared: (midiMsgType: \noteOnOff, elementType: \button,
				midiChan: 0, spec: \midiBut),
			elements: [
				(key: \rew, 	midiNum:  91),
				(key: \play, 	midiNum:  94),
				(key: \fwd, 	midiNum:  92),
				(key: \cycle, 	midiNum:  86),
				(key: \stop, 	midiNum:  93),
				(key: \rec, 	midiNum:  95)
			]
		)
	]
)
);