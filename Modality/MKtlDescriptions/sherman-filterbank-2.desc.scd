// Sherman Filterbank 2 Descriptionfile
(
deviceName: "Sherman FilterBank 2",
protocol: \midi,
deviceType: \filterbank,
elementTypes: [\button, \knob],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "Sherman FilterBank 2",

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",

),
elementsDesc: (
	shared: ('midiChan': 15),
	elements: [
		// MIDI coming in from the Sherman Filterbank
		(
			key: 'tr',
			shared: ('midiMsgType': 'noteOnOff', 'type': 'button',
				'spec': 'midiVel'),
			elements: [
				('midiNum':  78),
				('midiNum':  82)
			]
		),
		// MIDI being sent to the Sherman Filterbank:
		(
			key: 'cutFil1', 'midiMsgType': 'bend', 'type': 'knob',
			'midiChan': 15, 'spec': 'midiBend', 'ioType': 'out'),
		(
			key: 'resFil1', 'midiMsgType': 'touch', 'type': 'knob',
			'spec': 'midiTouch', 'ioType': 'out'),
		(
			key: 'cutFil2', 'midiMsgType': 'cc', 'type': 'knob',
			'midiNum': 1, 'spec': 'midiCC', 'ioType': 'out'),
		(
			key: 'resFil2', 'midiMsgType': 'cc', 'type': 'knob',
			'midiNum': 2, 'spec': 'midiCC', 'ioType': 'out'),
		(
			key: 'fmDepth', 'midiMsgType': 'cc', 'type': 'knob',
			'midiNum': 4, 'spec': 'midiCC', 'ioType': 'out'),
		(
			key: 'vcaBias', 'midiMsgType': 'cc', 'type': 'knob',
			'midiNum': 7, 'spec': 'midiCC', 'ioType': 'out'),
		(
			key: 'amDepth', 'midiMsgType': 'cc', 'type': 'knob',
			'midiNum': 11, 'spec': 'midiCC', 'ioType': 'out'),
		(
			key: 'attADSR', 'midiMsgType': 'cc', 'type': 'knob',
			'midiNum': 5, 'spec': 'midiCC', 'ioType': 'out'),
		(
			key: 'decADSR', 'midiMsgType': 'cc', 'type': 'knob',
			'midiNum': 16, 'spec': 'midiCC', 'ioType': 'out'),
		(
			key: 'relADSR', 'midiMsgType': 'cc', 'type': 'knob',
			'midiNum': 17, 'spec': 'midiCC', 'ioType': 'out'),
		(
			key: 'attAR', 'midiMsgType': 'cc', 'type': 'knob',
			'midiNum': 18, 'spec': 'midiCC', 'ioType': 'out'),
		(
			key: 'relAR', 'midiMsgType': 'cc', 'type': 'knob',
			'midiNum': 19, 'spec': 'midiCC', 'ioType': 'out')
	]
);
);
