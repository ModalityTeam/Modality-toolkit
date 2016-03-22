///////// Example for an external MIDI device ///////
/*
	Doepfer Pocket fader box has 16 sliders.

// For a usage example, see
"Tutorials/Connecting_external_MIDI_devices".openHelpFile;

*/

(
deviceName: "pocketfader",
protocol: \midi,
deviceType: \faderbox,
elementTypes: [\fader],
status: (
	linux: "unknown",
	osx: "tested and working. 2016-03-16, adc",
	win: "unknown"),

idInfo: "EXTERNAL",

deviceInfo: (
	vendorURI: "http://www.doepfer.de/pe.htm",
	manualURI: "http://www.doepfer.de/pdf/PE_manual.pdf",
	description: "MIDI faderbox (discontinued)",
	features: [
		"hardware midi plugs (no USB)",
		"MIDI configurable by DIP switches."],
	notes: "Available as a kit to build a customised 16 chan midi controller.",
	longName: "Doepfer Pocketfader",
),

elementsDesc: (
	key: \sl,
	shared: (elementType: \slider, midiMsgType: \control,
		midiChan: 0, spec: \midiCC, \ioType: \inout),
	elements: (
		(1..16).collect { |num, i| (key: num.asSymbol, midiNum: i) }
	)
)
);
