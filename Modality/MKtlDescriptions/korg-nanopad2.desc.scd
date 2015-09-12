///// nanoPAD2 desc file

/*
MIDIMKtl.find;
k = MIDIMKtl('nnpd20');
*/

(
deviceName: "nanoPAD2",
protocol: \midi,
deviceType: \drumpad,
elementTypes: [\pad, \touchpad, \button],
status: "unknown",

idInfo: "nanoPAD2",

deviceInfo: (
	vendorURI: "http://www.korg.com/us/products/controllers/nanopad2/",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",

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