///// nanoPAD2 desc file

/*
MIDIMKtl.find;
k = MIDIMKtl('np', "nanoPAD2");
*/

(
deviceName: "nanoPAD2",
protocol: \midi,
deviceType: \drumpad,
elementTypes: [\pad, \touchpad, \button],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "nanoPAD2",

deviceInfo: (
	vendorURI: "http://www.korg.com/us/products/controllers/nanopad2/",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",

),
elementsDesc: (
	shared: ('midiChan': 0),
	elements: [
		(
			key: \pad,
			shared: (\midiMsgType: \noteOnOff, \type: \key,
				\spec: \midiNote, \ioType: \in),
			elements: (36..99).collect { |num|
				(midiNum: num)
			}
		),
		(
			key: 'touch',
			shared: ('midiMsgType': 'cc', 'type': 'slider', 'spec': 'midiCC'),
			elements: [
				(key: \x, 'midiNum':  1),
				(key: \y, 'midiNum':  2),
				(key: \on, 'midiNum':  16)
			]
		)
	]
)
)