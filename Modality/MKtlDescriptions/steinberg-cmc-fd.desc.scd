/*
todo
*/
(
deviceName: "Steinberg CMC-FD",
protocol: \midi,
deviceType: \controller,
elementTypes: [\fader, \button],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo:"Steinberg CMC-FD",

deviceInfo: (
	vendorURI: "http://www.steinberg.net/en/products/controllers/cmc_series/models/cmc_fd.html",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",

),
description: (

// ------ noteOnOff -------------

// the buttons
'bankLeft': ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  46, 'spec': 'midiNote'),
'bankRight': ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  47, 'spec': 'midiNote'),
'chanLeft': ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  48, 'spec': 'midiNote'),
'chanRight': ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  49, 'spec': 'midiNote'),

'shift': ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  70, 'spec': 'midiNote'),

// fader touched or not
'faderTouch': (104..107).collect { |noteNum| ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  noteNum, 'spec': 'midiNote') },

// fader touched when shift is down sends channel mute
'faderMute': (8..11).collect { |noteNum| ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  noteNum, 'spec': 'midiNote') },

// ------- bend ------------
// high res fader values (10 bit )
'fader': (0..3).collect { |chan| ('midiMsgType': 'bend', 'type': 'bender', 'midiChan': 0, 'midiNum':  0,'spec': 'midiBend') }
);
)