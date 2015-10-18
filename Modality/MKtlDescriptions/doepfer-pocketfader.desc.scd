(
///////// Example for an external MIDI device ///////

deviceName: "pocketfader",
protocol: \midi,
deviceType: \faderbox,
elementTypes: [\fader],
status: (
	linux: "unknown",
	osx: "tested and working",
	win: "unknown"),

// replace with uid of a midi interface port,
// then redo openDevice to create this.
idInfo: "EXTERNAL",

deviceInfo: (
	vendorURI: "http://www.doepfer.de/pe.htm",
	manualURI: "http://www.doepfer.de/pdf/PE_manual.pdf",
	description: "Originally a 16 chan MIDI faderbox (now discontinued);"
	"\nnow a kit for making 16 chan midi controllers.",
	features: [
		"hardware midi plugs (no USB)",
		"MIDI configurable by DIP switches."],
	notes: "",

),

elementsDesc: (
	groupName: \sl,
	sharedProperties: (elementType: \slider, midiMsgType: \control,
			midiChan: 0, spec: \midiCC),
	elements: (
		(1..16).collect { |num, i| num.asSymbol -> (midiNum: i) }
	)
)
);
