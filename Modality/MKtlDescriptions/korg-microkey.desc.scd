(
deviceName: "microKEY",
protocol: 'midi',
deviceType: \keyboard,
elementTypes: [\pianoKey],
status: "unknown",

idInfo: "microKEY",

deviceInfo: (
	vendorURI: "http://www.korg.com/us/products/controllers/microkey/",
	// manualURI: "",
	// description: "",
	features: [
		"Velocity-sensitive mini-keyboard",
		"three models: 25-key / 37-key / 61-key"
	],
	// notes: "",
),
description: (

// ------ noteOn -------------
	'keyOn':
		(0..120).collect{ arg i;
			('midiMsgType': 'noteOn', 'type': 'key', 'midiChan': 0, 'midiNum':  i, 'spec': 'midiNote')
		},
// ------ noteOff -------------
	'keyOff':
		(0..120).collect{ arg i;
			('midiMsgType': 'noteOff', 'type': 'key', 'midiChan': 0, 'midiNum':  i, 'spec': 'midiNote')
		},
// ------ cc -------------
	'mod': ('midiMsgType': 'cc', 'type': 'wheel', 'midiChan': 0, 'midiNum':  1,'spec': 'midiCC'),

// ------- bend ------------
	'pitch': ('midiMsgType': 'bend', 'type': 'bender', 'midiChan': 0, 'midiNum':  0,'spec': 'midiBend')
)
);