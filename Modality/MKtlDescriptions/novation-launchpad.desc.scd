// Novation Launchpad specs:
// Mostly NoteOn / NoteOff, some cc messages,
// no hardware scenes, flattened out with underscores

/*
MKtlDesc.loadDescs("*launchpad");
m.free; m = MKtl(\lp, "*launchpad");  m.gui;
*/


(
deviceName: "Launchpad",
protocol: \midi,
deviceType: \launchpad,
elementTypes: [\button],
status: (
	linux: "unknown",
	osx: "now with gui layout. 2019_12_29, adc",
	win: "unknown"),

idInfo: "Launchpad",


deviceInfo: (
	vendorURI: "http://us.novationmusic.com/midi-controllers-digital-dj/launchpad",
	manualURI: "http://us.novationmusic.com/support/product-downloads?product=Launchpad",
	// description: "",
	features: [
		"64 multi-colour backlit buttons",
		"8 arrow buttons",
		"8 other buttons",
	],
	// notes: "",

	longName: "novation launchpad"
),
elementsDesc: (
	shared: (\midiChan: 0),
	elements: [
		(
			key: \bt,
			shared: (\midiMsgType: \cc, \elementType: \button,
				\spec: \midiBut, \mode: \push),
			elements: [
				(key: \up,     \midiNum: 104),
				(key: \down,   \midiNum: 105),
				(key: \left,   \midiNum: 106),
				(key: \right,  \midiNum: 107),
				(key: \session,\midiNum: 108),
				(key: \user1,  \midiNum: 109),
				(key: \user2,  \midiNum: 110),
				(key: \mixer,  \midiNum: 111)
			]
		),
		(
			key: \pad,
			shared: (\elementType: \pad, \spec: \midiVel),
			elements: ((0, 16 .. 112) +.t (0..7)).flat.clump(8).collect {|nums, i|
				(
					elements: nums.collect { |num, j|
						( groupType: \noteOnOff,
							style: (row: i + 1, column: j)
						)
					}
				)
			}
		),
		(
			key: \arr,
			shared: (\midiMsgType: \noteOn, \elementType: \pad, \spec: \midiVel),
			elements: ((0, 16 .. 112) + 8).flat.postln.collect {|num, i|
				(\midiNum: num)
			}
		)
	]
)
)
