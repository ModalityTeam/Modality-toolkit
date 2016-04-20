// Novation Launchpad specs:
// Mostly NoteOn / NoteOff, some cc messages,
// no hardware scenes, flattened out with underscores

(
deviceName: "Launchpad",
protocol: \midi,
deviceType: \launchpad,
elementTypes: [\button],
status: (
	linux: "unknown",
	osx: "tested desc, looks good. needs gui layout. 2016_03_23, adc",
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
			elements: ((0, 16 .. 112) +.t (0..7)).flat.collect {|num, i|
				(
					elements: [
						(key: \on, \midiMsgType: \noteOn, \midiNum: num),
						(key: \off, \midiMsgType: \noteOff, \midiNum: num)
					]
				)
			}
		),
		(
			key: \arr,
			shared: (\midiMsgType: \noteOn, \elementType: \pad, \spec: \midiVel),
			elements: ((0, 16 .. 112) + 8).flat.collect {|num, i|
				(\midiNum: num)
			}
		)
	]
)
)
