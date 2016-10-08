// Contributed by Nathan Ho.

/*

k = MKtl('o49', "m-audio-oxygen49");
a = Array.fill(9, 0);
m = MultiSliderView().elasticMode_(1).size_(9).front;
k.elAt(\sl).action_({ |el| a[el.parent.indexOf(el)] = el.value; { m.value = a; }.defer; });

*/

(
deviceName: "Oxygen 49",
protocol: 'midi',
deviceType: 'keyboard',
elementTypes: [\fader, \button, \knob, \key, \bend],
status: (
	linux: "working, no gui",
	osx: "unknown",
	win: "unknown"),

idInfo: "Oxygen 49",

deviceInfo: (
	vendorURI: "http://www.m-audio.com/",
	manualURI: "http://www.m-audio.com/products/view/oxygen-49",
	features: [
		"49-key velocity-sensitive keyboard",
		"Pitch bend and mod wheel",
		"9 faders",
		"9 buttons",
		"8 knobs",
		"8 transport buttons"
	],
	notes: "Works with factory preset P10 (selected because it is the only factory preset that detects release for the buttons). To reset your device to factory, hold down + and - while starting the keyboard.",
	longName: "M-Audio Oxygen 49"
),
elementsDesc: (
	elements: [
		(
			key: \bend,
			type: \wheel,
			midiChan: 0,
			midiMsgType: \bend,
			elementType: \bender,
			spec: \midiBend
		),
		(
			key: \mod,
			type: \wheel,
			midiChan: 0,
			midiMsgType: \cc,
			elementType: \wheel,
			spec: \midiCC,
			midiNum: 1
		),
		(
			key: \kn,
			shared: (type: \knob, midiMsgType: \cc, elementType: \cc, midiChan: 15, spec: \midiCC),
			elements: (17..24).collect { |midiNum| (midiNum: midiNum) }
		),
		(
			key: \bt,
			shared: (midiMsgType: \cc, elementType: \button, spec: \midiBut, midiChan: 15, mode: \push),
			elements: (49..57).collect { |midiNum| (midiNum: midiNum) }
		),
		(
			key: \tr,
			shared: (midiMsgType: \cc, elementType: \button, spec: \midiBut, midiChan: 15, mode: \push),
			elements: [
				(key: \prev, \midiNum: 110, style: (\showLabel: true)),
				(key: \next, \midiNum: 111, style: (\showLabel: true)),
				(key: \loop, \midiNum: 113, style: (\showLabel: true)),
				(key: \rew, \midiNum: 114, style: (\showLabel: true)),
				(key: \fwd, \midiNum: 115, style: (\showLabel: true)),
				(key: \stop, \midiNum: 116, style: (\showLabel: true)),
				(key: \play, \midiNum: 117, style: (\showLabel: true)),
				(key: \rec, \midiNum: 118, style: (\showLabel: true))
			]
		),
		(
			key: \sl,
			shared: (type: \slider, midiMsgType: \cc, elementType: \cc, midiChan: 15, spec: \midiCC),
			elements: (33..41).collect { |midiNum| (midiNum: midiNum) }
		),
		(
			key: \kn,
			shared: (type: \knob, midiMsgType: \cc, elementType: \cc, midiChan: 15, spec: \midiCC),
			elements: (17..24).collect { |midiNum| (midiNum: midiNum) }
		),
		(
			key: \pkey,
			shared: (elementType: \key, spec: \midiVel, midiChan: 0),
			elements: (0..127).collect { |midinum, i|
				MKtlDesc.notePair(i, midinum,
					(style: (row: i div: 24, column: i % 24))
				);
			}
		)
	]
)

);

