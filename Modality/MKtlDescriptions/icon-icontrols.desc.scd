
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
description: (

	bt: #[
		[ 16, 17, 18, 19, 20, 21, 22, 23, 48 ],
		[  8,  9, 10, 11, 12, 13, 14, 15, 49 ]
	].collect{ |xs, row|
		xs.collect { |note, column|
			(midiMsgType: \noteOnOff, elementType: \button, midiChan: 0, midiNum:  note, spec: \midiVel)
		}
	},
	sl:
	(0..8).collect { |i, n|
		(midiMsgType: \cc, elementType: \slider, midiChan: i, midiNum:  13, spec: \midiCC)
	},

	kn:((16..23)++[12]).collect { |i, n|
		(midiMsgType: \cc, elementType: \slider, midiChan: 0, midiNum:   i, spec: \midiCC)
	},
	rew:   (midiMsgType: \noteOnOff, elementType: \button, midiChan: 0, midiNum:  91, spec: \midiVel),
	play:  (midiMsgType: \noteOnOff, elementType: \button, midiChan: 0, midiNum:  94, spec: \midiVel),
	fwd:   (midiMsgType: \noteOnOff, elementType: \button, midiChan: 0, midiNum:  92, spec: \midiVel),
	cycle: (midiMsgType: \noteOnOff, elementType: \button, midiChan: 0, midiNum:  86, spec: \midiVel),
	stop:  (midiMsgType: \noteOnOff, elementType: \button, midiChan: 0, midiNum:  93, spec: \midiVel),
	rec:   (midiMsgType: \noteOnOff, elementType: \button, midiChan: 0, midiNum:  95, spec: \midiVel),
)
)