///// nanoPAD2 desc file

/*
MIDIMKtl.find;
k = MIDIMKtl('nnpd20');
*/

(
idInfo: "nanoPAD2",
protocol: \midi,
deviceInfo: (
	vendorURI: "http://www.korg.com/us/products/controllers/nanopad2/",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",
	type: [\pad, \touchpad, \button],
),
description: (
	\pad: (
		\on: (36..99).collect{ |num|
			(\midiMsgType: \noteOn , \type: \key, \midiChan: 0, \midiNum: num, \spec: \midiNote, \ioType: \in)
		},
		\off: (36..99).collect{ |num|
			(\midiMsgType: \noteOff, \type: \key, \midiChan: 0, \midiNum: num, \spec: \midiNote, \ioType: \in)
		}
	),

	'touchX': ('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 0, 'midiNum':  1,'spec': 'midiCC'),
	'touchY': ('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 0, 'midiNum':  2,'spec': 'midiCC'),
	'touchInUse': ('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 0, 'midiNum':  16,'spec': 'midiCC'),
)
)