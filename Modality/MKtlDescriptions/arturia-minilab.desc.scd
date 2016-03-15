
/// pads (36..43) overlap with keys (36-72)?

/*
TODO:
* add gui layout


thisProcess.nowExecutingPath.basename.split($.).first.postcs;
d = MKtlDesc.loadDescs("*minilab").first;
d.web;

m.free; m = MKtl(\mpk, "*minilab"); m.gui;
m.trace;
m.elementsDict.size;
m.postElements;

Ndef(\test, { |amp = 0.2, cutoff = 1000, reso = 5|
	RLPF.ar(Saw.ar(100, amp ! 2), cutoff, 1/reso);
}).play;
Ndef(\test).addSpec(\cutoff, [800, 10000, \exp]);
Ndef(\test).addSpec(\reso, [0.5, 100, \exp]);

m.elAt(\kn, 0, 0).action = { |el| Ndef(\test).setUni(\amp, el.value.postln) };
m.elAt(\kn, 0, 0).action = { |el| Ndef(\test).setUni(\cutoff, el.value.postln) };
m.elAt(\kn, 0, 0).action = { |el| Ndef(\test).setUni(\reso, el.value.postln) };
*/

(
deviceName: "Arturia MINILAB",
protocol: \midi,
deviceType: \midiKeyboard,
elementTypes: [\pianoKey, \encoder, \button],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "Arturia MINILAB",

deviceInfo: (
	vendorURI: "http://www.arturia.com/products/hybrid-synths/minilab/overview",
	manualURI: "http://downloads.arturia.com/products/minilab/manual/MiniLab_Manual_EN.pdf",
	// description: "",
	features: [
		"8x8 clip matrix with tri-color lighting",
		"9 assignable faders",
		"buttons and directional arrows",
	],
	notes: "Desc file only for absolute knob mode.",
	// hasScribble: false
),
elementsDesc: (
	shared: (midiChan: 0),
	elements: [
		(
			key: \pkey,
			shared: (elementType: 'pianoKey', spec: 'midiVel'),
			elements: (36..72).collect  { |num, i| MKtlDesc.notePair(midiNum: num) } ),
		(
			key: \pad,
			shared: (elementType: 'pad', spec: 'midiVel'),
			/// pads overlap with keys???
			elements: (36..43).collect { |num, i| MKtlDesc.notePair(midiNum: num) } ),
	// ... pads bank 2: (22..29) ...
		(
			key: \kn,
			shared: (midiMsgType: 'cc', elementType: 'knob', midiChan: 0,
				spec: 'midiCC'),
			elements: [
				[7, 74, 71, 76, 77, 93, 73, 75],
				[114, 18, 19, 16, 17, 91, 79, 72]
			].collect { |line|
				(elements: line.collect { |num| (midiNum:  num) })
			}
		),
		(
			key: \mod,
			midiMsgType: 'cc', elementType: 'slider', midiChan: 0,
			midiNum: 1, spec: 'midiCC'),
		(
			key: \bend, midiMsgType: 'bend', elementType: 'bender',
			midiChan: 0, spec: 'midiBend')
	]
)
)
