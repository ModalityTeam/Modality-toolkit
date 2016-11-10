// ICON I-Stage specs:
// Mostly NoteOn / NoteOff, some cc messages,
// hardware scenes: DJ, Effector and Drummer seems to work, flattened out with underscores.

/*

TODO:
* has 611 elements ATM .. is this correct?
* will need GUI layout, by somebody who knows what exactly?
* will need some kind of gui paging with 600+ elements.
* did simple gui paging, I hope this is correct. FIXME PLEASE.
***

thisProcess.nowExecutingPath.basename.split($.).first.postcs;
d = MKtlDesc.loadDescs("*istage").first;
d.elementsDict.size;
d.postElements;
// d.web;
m.free; m = MKtl(\ic, "*istage"); m.gui; m.trace;
*/

(
deviceName: "iCON iStage V1.00",
protocol: \midi,
deviceType: \drumpad,
elementTypes: [\pad, \button, \fader, \display, \led],
status: (
	linux: "unknown",
	osx: "tested desc only, seems to work. needs gui layout! 2016-03-23, adc.",
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
	longName: "iCON iStage"
),
elementsDesc: (
	elements: [
		(
			key: \cf, \midiMsgType: \cc, \elementType: \xfader,
			\midiChan: 0, \midiNum: 7, \spec: \midiCC,
			style: (row: 4, column: 0, width: 2, height: 1)
		),
		(
			// just put these somewhere, and on 12 pages - fix when we know how.
			key: \bt,
			shared: (\elementType: \pad,
			spec: \midiBut, \mode: \push),
			elements: (0..19).collect { |num, j|
				(
					// guessing that these are paged?
					shared: (groupType: \noteOnOffBut),
					elements: (0..11).collect { |chan, i|
						(midiNum: num, shared: (midiChan: chan, page: i,
							style: (row: 6, column: j * 0.8))
						)
					}
				)
			}
		),
		(
			// just put them somewhere, fix when we know which page etc
			key: \play,
			shared: (\elementType: \pad, groupType: \noteOnOffBut, \midiChan: 12,
			spec: \midiBut, \mode: \push),
			elements: (0..19).collect { |num, j|
				(midiNum: num, shared: (style: (row: 7, column: j * 0.8)))
			}
		),

		(
			// these are physically correctly placed
			key: \stop,
			shared: (\elementType: \pad, groupType: \noteOnOffBut, \midiNum: 103,
				spec: \midiBut, \mode: \push),
			elements: (0..12).collect { |chan, i|
				(midiNum: 103, shared: (midiChan: chan, style: (row: 4, column: i + 2))
				)
			}
		),

	// drummer
		(
			key: \bluL,
			shared: (\elementType: \pad, groupType: \noteOnOffBut, \midiChan: 9,
			spec: \midiVel, \mode: \push),
			elements: (60..75).collect { |num, i|
				(midiNum: num, shared: (style: (row: i div: 4, column: i % 4 + 2)))
			}
		),

		// duplication in here (42)!
		(
			key: \red,
			shared: (\elementType: \pad, groupType: \noteOnOffBut, \midiChan: 9,
				spec: \midiVel, \mode: \push),
			elements: #[35,48,37,36, 49,47,40,38, 50,45,42,42, 51,43,46,44]
			.collect { |num, i|
				(midiNum: num, shared: (style: (row: i div: 4, column: i % 4 + 6)))
			}
		)
	]

/*++
// left blue is duplicate of red
#[35, 48, 37, 36, 49, 47, 40, 38, 50, 45, 42, 42, 51, 43, 46, 44].collect{|num, i|
	[("red" ++ i.asStringToBase(10, 2)).asSymbol, (\elementType: \button, \midiChan: 9, \midiNum: num, spec: \midiBut, \mode: \push)]
}.flat
*/

)
)