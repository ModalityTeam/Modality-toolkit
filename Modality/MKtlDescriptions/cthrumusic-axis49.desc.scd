/*
m.free; m = MKtl(\ax, "*axis49"); m.gui;



// gui layout sketch:
// I don't know what the real midi numbers on each pad,
// so this is just for making the pads geometrically

w = Window("axis49 - selfless layout, 98 keys in columns",
	Rect(0,0,600,320)
).front;

b = (1..98).clump(7).collect { |col, i|
	var width = 40, angle = 0.0;
	col.collect { |num, j|
		var left = i * width * 0.8;
		var rightHalfShift =(i >= 7 and: i.even).binaryValue;
		var top = 6 - (j % 7) + (i % 2 * 0.5) + rightHalfShift * width;

		MHexPad(w, Rect(left, top, width, width))
		.angle_(0.0)
		.label_(num);
	};
};

// 49key doubled layout
// - how to create two hexpads for each doubled key?
// it's a one-off case, so better put it in its own class or extra sketch.



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

