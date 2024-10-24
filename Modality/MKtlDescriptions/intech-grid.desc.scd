
/**** desc file for intech EN16 4x4 grid of encoders.

MKtlDesc.loadDescs("intech-grid");

k.free; k = MKtl('grid', "*grid"); k.gui;
k.elAt(\enc).action = { |el| [el.name, el.deviceValue, el.value.round(0.001)].postln };
k.elAt(\bt).action = { |el| [el.name, el.deviceValue, el.value.round(0.001)].postln };

Questions / To Do:
Is there a way to set it to relative mode?
https://docs.intech.studio/guides/introduction

Would be useful to set encoders to values from SC - how?
naively declaring (ioType: \inout) does not work.
some other ccnums?

****/

(
deviceName: "Grid",
protocol: 'midi',
deviceType: 'encoder bank',
elementTypes: [  ],
status: (
	linux: "unknown",
	osx: "working, 24_09_19, adc",
	win: "unknown"),

idInfo: "Grid",

// hardwarePages: [1, 2, 3, 4],

deviceInfo: (
	vendorURI: 'https://intech.studio/shop/en16/',
	manualURI: 'https://docs.intech.studio/guides/introduction',
	description: "4x4 grid of 16 encoders with pushbuttons.",
	features: ["4x4 grid of 16 encoders with pushbuttons."],
	notes: "",
	hasScribble: false
),
elementsDesc: (
	shared: (midiChan: 0),
	elements: [
		(
			key: \enc,
			shared: ('midiMsgType': 'cc', 'elementType': 'encoder', 'spec': 'midiCC'),
			elements: (32..47).collect { |midinum, i|
				(midiNum: midinum, style: (column: i % 4 * 1.5, row: (i div: 4 * 1.5 + 0.5)))
			}
		),
		(
			key: \bt,
			shared: ('groupType': 'noteOnOff', 'elementType': 'button', 'spec': 'midiBut'),
			elements: (32..47).collect { |midinum, i|
				(midiNum: midinum, style: (column: i % 4 * 1.5, row: (i div: 4 * 1.5), height: 0.5))
			}
		),
	]
)
);

