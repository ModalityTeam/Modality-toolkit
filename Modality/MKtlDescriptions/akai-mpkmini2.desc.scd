// contributed by gil fuser

/*
* todo:
* test on osx
* add gui layout

MKtl(\x, "*mpk*2").gui;
MKtl(\x).trace;
*/

(
deviceName: "MPKmini2",
protocol: 'midi',
deviceType: 'keyboard',
elementTypes: [\knob, \key, \pad, \bend],
status: (
	linux: "tested and working",
	osx: "tested desc only, looks ok, no gui info yet. 2016-03-17, adc",
	win: "tested and working"),

idInfo: "MPKmini2",

// hardwarePages: [1, 2, 3, 4],

deviceInfo: (
	vendorURI: 'http://www.akaipro.com/product/mpk-mini-mkii',
	manualURI: 'http://6be54c364949b623a3c0-4409a68c214f3a9eeca8d0265e9266c0.r0.cf2.rackcdn.com/988/documents/MPK%20mini%20-%20User%20Guide%20-%20v1.0.pdf',
	description: "mini midi-keyboard with pressure-sensitive pads, knobs and a bender. Have four programs",
	features: [\pianoKey, \pad, \knob, \bender],
	notes: "this description is made for the default presets. Every key was mapped, with the exception of Prog Change.
Whenever use Prog Change in the device, one must click Bank A/B. Otherwise the pads won't be found and a rather random midiNum will be assined to each of them.
For grater flexibility use the MPK MiniMKII - Editor, which can be found here: http://www.akaipro.com/product/mpk-mini-mkii#downloads",
	// hasScribble: false
),
elementsDesc: (
	elements: [

		// ------- bend ------------
		( key: \bend,
			\midiChan: 0, \midiMsgType: \bend, \elementType: \bender, \spec: \midiBend
		),
		// ------ pad -------------
		(
			key: \pad,
			shared: (\midiMsgType: \noteOnOff, \midiChan: 9, \spec: \midiCC),
			elements: ((36..38)++(40)++(42..53)++(55)++(57)++(59..75)++(82)).collect { |i|
				(key: (i).asSymbol, \midiNum: i)
			}
		),
		// ------ pad into button -------------
		(
			key: \bt,
			shared: (\midiMsgType: \cc, \elementType: \button, \spec: \midiCC ),
			elements: [

				(
					shared: (\midiChan: 0),
					elements: (28..35).collect { |i|
						(key: (i).asSymbol, \midiNum: i)
					}
				),
				(
					shared: (\midiChan: 9),
					elements: (0..16).collect { |i|
						(key: (i).asSymbol, \midiNum: i)
					}
				),



			]
		),
		// ------ knob -------------
		(
			key: \kn,
			shared: (\midiMsgType: \cc, \elementType: \knob,
				\midiChan: 0, \spec: \midiCC),
			elements: ((1..8)++(16..27)).collect { |i, item|
				item = item + 1;
				(key: (i).asSymbol, \midiNum: i)
			}
		),
		// ------ piano key -------------
		(
			key: \key,
			shared: (\midiMsgType: \noteOnOff, \elementType: \pianoKey,
				\midiChan: 0, \spec: \midiVel),
			elements: (0..120).collect { |i|
				(key: (i).asSymbol, \midiNum: i)
			}
		),
	]
)

);

