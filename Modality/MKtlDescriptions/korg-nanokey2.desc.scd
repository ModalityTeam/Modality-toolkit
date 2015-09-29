(
deviceName: "nanoKEY2",
protocol: 'midi',
deviceType: \keyboard,
elementTypes: [\pianoKey, \button],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "nanoKEY2",

deviceInfo: (
	vendorURI: "http://www.korg.com/us/products/controllers/nanokey2/",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",

),
description: (
	'keyOn':
	(0..120).collect{ arg i;
		('midiMsgType': 'noteOn', 'type': 'key', 'midiChan': 0, 'midiNum':  i, 'spec': 'midiNote')
	},
	'keyOff':
	(0..120).collect{ arg i;
		('midiMsgType': 'noteOff', 'type': 'key', 'midiChan': 0, 'midiNum':  i, 'spec': 'midiNote')
	},
	// ------ cc -------------
	'mod': ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum':  1,'spec': 'midiCC'),
	'sustain': ('midiMsgType': 'cc', 'type': 'button', 'midiChan': 0, 'midiNum':  64,'spec': 'midiCC'),

	// ------- bend ------------ these are actually two buttons!
	'pitch': ('midiMsgType': 'bend', 'type': 'bender', 'midiChan': 0, 'midiNum':  0,'spec': 'midiBend'),
)
);
