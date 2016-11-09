
(
deviceName: "VMeter 1.30 A",
protocol: \midi,
deviceType: \fader,
elementTypes: [\fader],
status: (
	linux: "unknown",
	osx: "tested desc, looks good. 2016-03-23, adc",
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
		(key: \sl, elementType: \slider, ioType: \inout,
			'midiMsgType': 'cc', 'midiChan': 0, 'midiNum':  20,'spec': 'midiCC')
	]
)
)