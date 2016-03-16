// Sherman Filterbank 2 Descriptionfile
/*
m = MKtl(\x, "*bank-2");
m.gui;
*/
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
			shared: ('elementType': 'button', 'spec': 'midiBut'),
			elements: [
				MKtlDesc.notePair(0, 78, (style: (row: 0, column: 0)) ),
				MKtlDesc.notePair(1, 82, (style: (row: 0, column: 1)) )
			]
		),
		// MIDI being sent to the Sherman Filterbank:
		(
			key: 'cutFil1', 'midiMsgType': 'bend', 'elementType': 'knob',
			'midiChan': 15, 'spec': 'midiBend', 'ioType': 'out'),
		(
			key: 'resFil1', 'midiMsgType': 'touch', 'elementType': 'knob',
			'spec': 'midiTouch', 'ioType': 'out'),
		(
			key: 'cutFil2', 'midiMsgType': 'cc', 'elementType': 'knob',
			'midiNum': 1, 'spec': 'midiCC', 'ioType': 'out'),
		(
			key: 'resFil2', 'midiMsgType': 'cc', 'elementType': 'knob',
			'midiNum': 2, 'spec': 'midiCC', 'ioType': 'out'),
		(
			key: 'fmDepth', 'midiMsgType': 'cc', 'elementType': 'knob',
			'midiNum': 4, 'spec': 'midiCC', 'ioType': 'out'),
		(
			key: 'vcaBias', 'midiMsgType': 'cc', 'elementType': 'knob',
			'midiNum': 7, 'spec': 'midiCC', 'ioType': 'out'),
		(
			key: 'amDepth', 'midiMsgType': 'cc', 'elementType': 'knob',
			'midiNum': 11, 'spec': 'midiCC', 'ioType': 'out'),
		(
			key: 'attADSR', 'midiMsgType': 'cc', 'elementType': 'knob',
			'midiNum': 5, 'spec': 'midiCC', 'ioType': 'out'),
		(
			key: 'decADSR', 'midiMsgType': 'cc', 'elementType': 'knob',
			'midiNum': 16, 'spec': 'midiCC', 'ioType': 'out'),
		(
			key: 'relADSR', 'midiMsgType': 'cc', 'elementType': 'knob',
			'midiNum': 17, 'spec': 'midiCC', 'ioType': 'out'),
		(
			key: 'attAR', 'midiMsgType': 'cc', 'elementType': 'knob',
			'midiNum': 18, 'spec': 'midiCC', 'ioType': 'out'),
		(
			key: 'relAR', 'midiMsgType': 'cc', 'elementType': 'knob',
			'midiNum': 19, 'spec': 'midiCC', 'ioType': 'out')
	]
);
);
