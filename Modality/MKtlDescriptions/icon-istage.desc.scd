// ICON I-Stage specs:
// Mostly NoteOn / NoteOff, some cc messages,
// hardware scenes: DJ, Effector and Drummer seems to work, flattened out with underscores.

(
deviceName: "iCON iStage V1.00",
protocol: \midi,
deviceType: \drumpad,
elementTypes: [\pad, \button, \fader, \display, \led],
status: "unknown",

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
description: (
	\cf: (\midiMsgType: \cc, \type: \xfade,   \midiChan: 0, \midiNum: 7, \spec: \midiCC),
	\bt: (0..19).collect{|num| (0..11).collect{|chan|
		(\midiMsgType: \noteOnOff, \type: \button, \midiChan: chan, \midiNum: num, spec: \midiBut, \mode: \push)
}},
	\play: (0..19).collect{|num|
		(\midiMsgType: \noteOnOff, \type: \button, \midiChan: 12, \midiNum: num, spec: \midiBut, \mode: \push)
	},
	\stop: (0..12).collect{|chan|
		(\midiMsgType: \noteOnOff, \type: \button, \midiChan: chan, \midiNum: 103, spec: \midiBut, \mode: \push)
	},
	// drummer
	bluL: (60..75).collect{|num|
		(\midiMsgType: \noteOnOff, \type: \button, \midiChan: 9, \midiNum: num, spec: \midiVel, \mode: \push)
	},
// duplication in here (42)!
	red: #[35, 48, 37, 36, 49, 47, 40, 38, 50, 45, 42, 42, 51, 43, 46, 44].collect{|num, i|
		(\midiMsgType: \noteOnOff, \type: \button, \midiChan: 9, \midiNum: num, spec: \midiVel, \mode: \push)
	}
/*++
// left blue is duplicate of red
#[35, 48, 37, 36, 49, 47, 40, 38, 50, 45, 42, 42, 51, 43, 46, 44].collect{|num, i|
	[("red" ++ i.asStringToBase(10, 2)).asSymbol, (\midiMsgType: \noteOnOff, \type: \button, \midiChan: 9, \midiNum: num, spec: \midiBut, \mode: \push)]
}.flat
*/

)
)