/*
m.free; m = MKtl(\ax, "*axis49"); m.gui;
*/
(
deviceName: "AXIS-49 USB Keyboard",
protocol: 'midi',
deviceType: 'midiKeyboard',
elementTypes: [ \keys ],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "AXIS-49 USB Keyboard",

deviceInfo: (
	vendorURI: 'http://www.c-thru-music.com/cgi/?page=prod_axis-49',
	manualURI: 'http://www.c-thru-music.com/cgi/?page=spec-49',
	description:  "Velocity sensitive MIDI keyboard with Harmonic Table note arrangement.",
	// features: [],
	// notes: ,
	longName: "C-THRU MUSIC AXiS-49"
	),
status: (
	win: "unknown",
	osx: "tested and working, 15.3.2016, LFsaw.de, gui not done yet.",
	linux: "unknown"
),
elementsDesc: (
	shared: (
		'midiChan': 0,
		'elementType': 'pad', // or maybe hexPad.
		'spec': 'midiNote',
		midiMsgType: \noteOn,
		groupType: \noteOnOff
	),
	elements: (0..120).collect {
		|num, i|
		(key: num.asSymbol, midiNum: num,
			// at least show them all
			shared: (style: (column: i % 12, row: i div: 12))
		)
	}
)
);

