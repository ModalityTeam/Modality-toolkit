
/// pads (36..43) overlap with keys (36-72)?

/*
TODO:
* add gui layout


thisProcess.nowExecutingPath.basename.split($.).first.postcs;
d = MKtlDesc.loadDescs("*minilab").first;
// d.web;

m.free; m = MKtl(\mnl, "*minilab"); m.gui;
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
	osx: "tested desc only, looks ok, no gui info yet. 2016-03-17, adc",
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
	notes: "only absolute knob mode supported.",
	longName: "Arturia MINILAB"
	// hasScribble: false
),
elementsDesc: (
	shared: (midiChan: 0),
	elements: [
		(
			key: \pkey,
			shared: (elementType: 'pianoKey', groupType: \noteOnOff, spec: 'midiVel'),
			// was 36-72, I assume it should be 48-72
			elements: (48..72).collect  { |num, i|
				var pos = Piano.pos(num, 48);
				(
					key: num.asSymbol, midiNum: num,
					shared: (style: (
						row: pos.y * 0.8 + 3,
						column: pos.x * 0.55 + 2,
						width: 0.7,
						color: pos.color))
				)
			}
		),
		(
			key: \pad,
			shared: (elementType: 'pad', groupType: \noteOnOff, spec: 'midiVel'),
			/// if keys begin with 36 as well, pads would overlap with keys
			elements: (36..43).collect { |num, i|
				(
					midiNum: num,
					shared: (style: (row: 2, column: i + 2))
				)
		} ),
		// ... pads bank 2: (22..29) ...
		(
			key: \kn,
			shared: (midiMsgType: 'cc', elementType: 'knob', midiChan: 0,
				spec: 'midiCC'),
			elements: [
				[7, 74, 71, 76, 77, 93, 73, 75],
				[114, 18, 19, 16, 17, 91, 79, 72]
			].collect { |line, j|
				(elements: line.collect { |num, i|
					(
						midiNum:  num,
						style: (row: j, column: i + 2)
					)
				})
			}
		),
		(
			key: \bend, midiMsgType: 'bend', elementType: 'bender',
			midiChan: 0, spec: 'midiBend', style: (row: 3, column: 0, height: 2)
		),
		(
			key: \mod,
			midiMsgType: 'cc', elementType: 'slider', midiChan: 0,
			midiNum: 1, spec: 'midiCC', style: (row: 3, column: 1, height: 2)
		),
	]
)
)
