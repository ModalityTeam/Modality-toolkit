// Contributed by Nathan Ho.
// updated for 0.9.0 by adc

/*
MKtlDesc.loadDescs("*oxygen49");
k.free; k = MKtl('o49', "m-audio-oxygen49");
k.trace.gui;

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
			elementType: \bender,
			midiChan: 0,
			midiMsgType: \bend,
			spec: \midiBend,
			style: (height: 2)
		),
		(
			key: \mod,
			elementType: \bender,
			midiChan: 0,
			midiMsgType: \cc,
			spec: \midiCC,
			midiNum: 1,
			style: (height: 2)
		),
		(
			key: \sl,
			shared: (elementType: \slider, midiMsgType: \cc, midiChan: 15, spec: \midiCC),
			elements: (33..41).collect { |midiNum, i|
				(midiNum: midiNum, style: (row: 0, column: i + 6, height: 2))
			}
		),
		(
			key: \bt,
			shared: (midiMsgType: \cc, elementType: \button, spec: \midiBut, midiChan: 15, mode: \push),
			elements: (49..57).collect { |midiNum, i|
				(midiNum: midiNum, style: (row: 2, column: i + 6))
			}
		),
		(
			key: \kn,
			shared: (elementType: \knob, midiMsgType: \cc, midiChan: 15, spec: \midiCC),
			elements: (17..24).collect { |midiNum, i|
				(midiNum: midiNum, style: (row: i div: 4, column: 16 + (i % 4 + (i div: 4 * 0.5))))
			}
		),
		(
			key: \tr,
			shared: (midiMsgType: \cc, elementType: \button, spec: \midiBut, midiChan: 15, mode: \push),
			elements: [
				(key: \prev, \midiNum: 110, style: (row: 0, column: 2,  width: 1.2)),
				(key: \next, \midiNum: 111, style: (row: 0, column: 3,  width: 1.2)),

				(key: \loop, \midiNum: 113, style: (row: 2, column: 16, width: 1.2)),
				(key: \rew, \midiNum: 114,  style: (row: 2, column: 17, width: 1.2)),
				(key: \fwd, \midiNum: 115,  style: (row: 2, column: 18, width: 1.2)),
				(key: \stop, \midiNum: 116, style: (row: 2, column: 19, width: 1.2)),
				(key: \play, \midiNum: 117, style: (row: 2, column: 20, width: 1.2)),
				(key: \rec, \midiNum: 118,  style: (row: 2, column: 21, width: 1.2))
			]
		),
		(
			key: \pkey,
			shared: (elementType: \pianoKey, spec: \midiVel, midiChan: 0),
			elements: (0..127).collect { |midinum, i|
				var pos = Piano.pos(midinum % 48, 0);
				(key: i.asSymbol,
					groupType: \noteOnOff,
					shared: (
						groupType: \noteOnOff,
						midiNum: midinum,
						style: (
							row: 7 - (i div: 48 * 2) + (pos.y * 0.9),
							column: pos.x * 0.8,
							color: pos.color,
							height: 1.2,
							showLabel: true
						)
					)
				);
			}
		)
	]
)
);

