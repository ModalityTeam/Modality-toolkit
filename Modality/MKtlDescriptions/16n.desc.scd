///////// Example for an external MIDI device ///////
/*
  This is the default slider values for the 16n faderbank device.
*/

(
deviceName: "16n",
protocol: \midi,
deviceType: \faderbox,
elementTypes: [\fader],
status: (
	linux: "unknown",
	osx: "tested and working. 2021-04-30",
	win: "unknown"),

idInfo: "16n",

deviceInfo: (
	vendorURI: "https://16n-faderbank.github.io/",
	manualURI: "https://github.com/16n-faderbank/16n/wiki/",
	description: "Sixteen MIDI faders and CV outputs with i2c",
	features: [
		"i2c",
		"MIDI trs and USB (depending on build)"],
	notes: "Available as a kit to build a customised 16 chan midi controller.",
	longName: "16n",
),

elementsDesc: (
	key: \sl,
	shared: (elementType: \slider, midiMsgType: \control,
		midiChan: 0, spec: \midiCC, \ioType: \inout),
	elements: (
		(1..16).collect { |num, i| (key: num.asSymbol, midiNum: 22 + num) }
	)
)
);

