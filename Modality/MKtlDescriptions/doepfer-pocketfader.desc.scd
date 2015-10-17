(

///////// SPECIFIC INFORMATION for this port and config: ///////

deviceName: "pocketfader",
protocol: \midi,
deviceType: \faderbox,
elementTypes: [\fader],
status: (
	linux: "unknown",
	osx: "tested and working",
	win: "unknown"),

idInfo: "EXTERNAL",

deviceInfo: (
	vendorURI: "http://www.doepfer.de/pe.htm",
	manualURI: "http://www.doepfer.de/pdf/PE_manual.pdf",
	description: "originally a 16 chan faderbox (discontinued); now a kit for making 16 chan midi controllers.",
	features: [],
	notes: "",

),

description: (
	sl: (0..15).collect { |i|
		(elementType: \slider, midiMsgType: \control,
			midiChan: 0, midiNum: i, spec: \midiCC)
	}
)
);
