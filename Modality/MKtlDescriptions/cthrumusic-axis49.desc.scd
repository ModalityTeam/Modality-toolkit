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
		'elementType': 'key',
		'spec': 'midiNote'
	),
	elements: (0..120).collect{|num, i|
		MKtlDesc.notePair(num.asSymbol, num)
	}
)
);

