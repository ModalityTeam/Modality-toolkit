/*
- while shift is held, pads are off, but other buttns and knob are on.
- is browse button and note 58 the same note? clarify.
- write litte example using some controls.

*/
(
idInfo:"Steinberg CMC-PD",
protocol: \midi,
deviceInfo: (
	vendorURI: "http://www.steinberg.net/en/products/controllers/cmc_series/models/cmc_pd.html",
	// manualURI: "",
	// description: "",
	// features: "",
	// notes: "",
	type: [\pad, \button]
),
description:

(
// ------ noteOnOff -------------
'pad': (52..63).collect ({ |num| ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum': num, 'spec': 'midiNote') }),

'shift': ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  70, 'spec': 'midiBut'),
'curveSetup': ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  114, 'spec': 'midiNote'),
'4velMode': ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  115, 'spec': 'midiNote'),
'browse': ('midiMsgType': 'noteOnOff', 'type': 'key', 'midiChan': 0, 'midiNum':  58, 'spec': 'midiNote'),

// ------ cc -------------
'kn': ('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 0, 'midiNum':  60,'spec': 'midiCC'),
)
);