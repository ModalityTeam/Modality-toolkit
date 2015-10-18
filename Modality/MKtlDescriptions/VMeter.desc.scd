//VMeter desc file

/*
MIDIMKtl.find;
k = MIDIMKtl('vmtr', "vmeter");
k.verbose_(true);
*/

(
deviceName: "VMeter 1.30 A",
protocol: \midi,
deviceType: \fader,
elementTypes: [\fader],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "VMeter 1.30 A",

deviceInfo: (
	vendorURI: "http://www.vmeter.net/",
	// manualURI: "",
	// description: "",
	// features: [],
	notes: "out of production",

	// hasScribble: false
),
elementsDesc: (
	elements: [
		\slider -> (elementType: \slider, 'midiMsgType': 'cc',
			'midiChan': 0, 'midiNum':  20,'spec': 'midiCC')
	]
)
