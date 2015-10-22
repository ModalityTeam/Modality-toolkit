/*
todo: write little example here
*/
(
deviceName: "Steinberg CMC-FD",
protocol: \midi,
deviceType: \controller,
elementTypes: [\fader, \button],
status: (
	linux: "unknown",
	osx: "tested and working",
	win: "unknown"),

idInfo:"Steinberg CMC-FD",

deviceInfo: (
	vendorURI: "http://www.steinberg.net/en/products/controllers/cmc_series/models/cmc_fd.html",
	// manualURI: "",
	// description: "",
	// features: ["4 touch faders" ],
	notes: "discontinued.",

),
elementsDesc: (
	shared: ('midiMsgType': 'noteOnOff', 'elementType': 'button',
		'midiChan': 0, 'spec': 'midiBut'),
	elements: [
		// the buttons
		(
			key: \bt,
			elements: [
				(key: 'bankLeft',  'midiNum':  46),
				(key: 'bankRight', 'midiNum':  47),
				(key: 'chanLeft',  'midiNum':  48),
				(key: 'chanRight', 'midiNum':  49)
			]
		),
		(
			key: 'shift',
			'midiMsgType': 'noteOnOff', 'elementType': 'button', 'midiNum':  70, 'spec': 'midiBut'
		),
		// fader touched or not
		(
			key: 'faderTouch',
			shared: ('midiMsgType': 'noteOnOff', 'elementType': 'button',
				'midiChan': 0, 'spec': 'midiBut'),
			elements: (104..107).collect { |note, i|
				('midiNum': note)
			};
		),
		// fader touched when shift is down sends channel mute
		(
			key: 'faderMute',
			shared: ('midiMsgType': 'noteOnOff', 'elementType': 'key',
				'midiChan': 0, 'spec': 'midiNote'),
			elements: (8..11).collect { |noteNum|
				('midiNum':  noteNum)
			}
		),
		// bend : high res fader values (10 bit )
		(
			key: 'fader',
			shared: ('midiMsgType': 'bend', 'elementType': 'fader',
				'midiChan': 0, 'spec': 'midiBend'),
			elements: (0..3).collect { |chan|
				('midiChan': chan,'spec': 'midiBend')
			}
		)
	]
);
)

