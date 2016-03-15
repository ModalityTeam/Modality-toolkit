// ICON I-Stage specs:
// Mostly NoteOn / NoteOff, some cc messages,
// hardware scenes: DJ, Effector and Drummer seems to work, flattened out with underscores.

/*

TODO:
* has 611 elements ATM .. is this correct?
* will need GUI layout
* use some kind of paging for gui with 600+ elements.
***

thisProcess.nowExecutingPath.basename.split($.).first.postcs;
d = MKtlDesc.loadDescs("*istage").first;
d.web;

m.free; m = MKtl(\ic, "*istage"); m.gui;
m.trace;
m.elementsDict.size;
m.postElements;
*/

(
deviceName: "iCON iStage V1.00",
protocol: \midi,
deviceType: \drumpad,
elementTypes: [\pad, \button, \fader, \display, \led],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "iCON iStage V1.00",
deviceInfo: (
	vendorURI: "http://www.icon-global.com/Keyboards%2FPads_Pads_iStage.htm",
	// manualURI: "",
	// description: "",
	features: [
		"3 sets of “4x4” matrix control buttons with dual color LED backlight",
		"3 sets of “4x4” velocity-sensitive drum pads",
		"17 buttons with red LED",
		"2-segment LED display",
		"1 encoder for jog wheel for fast scrolling and other controls",
		"1 assignable fader",
	],
	// notes: "",

	// hasScribble: false
),
elementsDesc: (
	elements: [
		(
			key: \cf, \midiMsgType: \cc, \type: \xfade,
			\midiChan: 0, \midiNum: 7, \spec: \midiCC,
		),
		(
			key: \bt,
			shared: (\type: \button,
				spec: \midiBut, \mode: \push),
			elements: (0..19).collect { |num|
				(
					elements: (0..11).collect { |chan|
						MKtlDesc.notePair(midiNum: num, shared: (midiChan: chan))
					}
				)
			}),
		(
			key: \play,
			shared: (\type: \button, \midiChan: 12,
				spec: \midiBut, \mode: \push),
			elements: (0..19).collect { |num| MKtlDesc.notePair(midiNum: num) }),
		(
			key: \stop,
			shared: (\type: \button, \midiNum: 103,
				spec: \midiBut, \mode: \push),
			elements: (0..12).collect { |chan|
				MKtlDesc.notePair(midiNum: 103, shared: (midiChan: chan))
			}
		),

	// drummer
		(
			key: \bluL,
			shared: (\type: \button, \midiChan: 9,
				spec: \midiVel, \mode: \push),
			elements: (60..75).collect { |num| MKtlDesc.notePair(midiNum: num) }),

		// duplication in here (42)!
		(
			key: \red,
			shared: (\type: \button, \midiChan: 9,
				spec: \midiVel, \mode: \push),
			elements: #[35,48,37,36, 49,47,40,38, 50,45,42,42, 51,43,46,44]
			.collect { |num, i| MKtlDesc.notePair(midiNum: num) })
	]

/*++
// left blue is duplicate of red
#[35, 48, 37, 36, 49, 47, 40, 38, 50, 45, 42, 42, 51, 43, 46, 44].collect{|num, i|
	[("red" ++ i.asStringToBase(10, 2)).asSymbol, (\type: \button, \midiChan: 9, \midiNum: num, spec: \midiBut, \mode: \push)]
}.flat
*/

)
)