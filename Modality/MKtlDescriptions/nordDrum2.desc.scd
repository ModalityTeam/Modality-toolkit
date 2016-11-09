/****

nord drum2

minimal code examples for testing

// 1. make an Mktl for the nordDrum
k = MKtl(\nd2, "*nordDrum2"); MKtl(\nd2).gui;

// This will say that it is virtual only, because this desc
// has an idInfo : "EXTERNAL", which is not an existing port name.
// So we need to tell it which midi hardware interface we connect it to.
k.desc.fullDesc.at(\idInfo);

// 2. find out which midi interfaces are there:
MKtl.find(\midi);

z = ( 'destPortIndex': 0, 'srcPortIndex': 0, 'deviceName': "USB MIDI Device" );

k.openDeviceVia( z );
k.device;


k.trace;
k.trace(false)

m = {|which = 0, vel = 0.1|
Routine{
	k.elAt(\pad, which , \on).value = vel;
	0.01.wait;
	k.elAt(\pad, which , \off).value = 0;
}.play;
};


Tdef(\player, {
	var p;
	inf.do{|i|
		(i % 4 == 0).if({
			p = 0;
		},{
			p = 6.rand;
		});
		m.(p, 1.0.rand);
		0.125.wait
	}
}).play

k.elAt(\pad, 1).value = 1

****/

(
deviceName: "nord drum2",
protocol: 'midi',
deviceType: 'drum',
elementTypes: [ \pad, \knob ],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "EXTERNAL",

deviceInfo: (
vendorURI: 'http://www.nordkeyboards.com/products/nord-drum-2',
manualURI: 'http://www.nordkeyboards.com/downloads/nord-drum-2',
	description: "The Nord Drum 2 is a one of a kind drum synthesizer for drummers, percussionists and producers seeking unique and playable percussive sounds.

With an extremely lively dynamic response, flexible connectivity and a broad sound palette ranging from classic synthetic drums to life-like tuned percussion and acoustic drums, the Nord Drum 2 is both an inspiring instrument and an infinite source of sounds.",
	features: [
		"6-channel Percussion Synthesizer",
		"Second generation sound engine with Resonant Synthesis",
		"Subtractive synthesis and FM-synthesis",
		"Drive, Crush and EQ-effects per channel",
		"Repeat Mode for delay like effects",
		"6 generic inputs for drum pads and acoustic triggers",
		"Nord Pad input",
		"MIDI in/out and full CC-control",
		"Stereo Output",
		"Headphone Output"
	],
	// notes: "",
	hasScribble: false
),
elementsDesc: (
	 elements: [

		// // ------ cc -------------
		// ( key: 'cc_9_058', 'midiNum':  58, 'midiChan': 9, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
		// ( key: 'cc_9_070', 'midiNum':  70, 'midiChan': 9, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
		(
			key: \pad,
			shared: (\elementType: \pad, groupType: \noteOnOff,
				\midiChan: 9, \spec: \midiVel, \ioType: \inout
			),
			elements: [
				(key: '1', midiNum: 60, shared: (style: (row: 0, column: 0))),
				(key: '2', midiNum: 62, shared: (style: (row: 0, column: 1))),
				(key: '3', midiNum: 64, shared: (style: (row: 0, column: 2))),
				(key: '4', midiNum: 65, shared: (style: (row: 1, column: 0))),
				(key: '5', midiNum: 67, shared: (style: (row: 1, column: 1))),
				(key: '6', midiNum: 69, shared: (style: (row: 1, column: 2))),
			]
		),

	]
)

);

