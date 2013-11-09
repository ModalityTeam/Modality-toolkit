// ICON I-Stage specs: 
// Mostly NoteOn / NoteOff, some cc messages, 
// hardware scenes: DJ, Effector and Drummer seems to work, flattened out with underscores.

[
	\cf:		(\midiType: \cc, \type: \xfade,   \midiChan: 0, \midiNum: 7, \spec: \midiCC),
]
++
(0..19).collect{|num| (0..11).collect{|chan|
	[("bu_" ++ chan.asStringToBase(10, 2) ++ "_"++ num.asStringToBase(10, 2)).asSymbol, (\midiType: \note, \type: \button, \midiChan: chan, \midiNote: num, spec: \midiBut, \mode: \push)]
}}.flat
++
(0..19).collect{|num| 
	[("play_" ++ num.asStringToBase(10, 2)).asSymbol, (\midiType: \note, \type: \button, \midiChan: 12, \midiNote: num, spec: \midiBut, \mode: \push)]
}.flat
++
(0..12).collect{|chan| 
	[("stop_" ++ chan.asStringToBase(10, 2)).asSymbol, (\midiType: \note, \type: \button, \midiChan: chan, \midiNote: 103, spec: \midiBut, \mode: \push)]
}.flat
++
// drummer
(60..75).collect{|num|
	[("bluL_" ++ num.asStringToBase(10, 2)).asSymbol, (\midiType: \note, \type: \button, \midiChan: 9, \midiNote: num, spec: \midiVel, \mode: \push)]
}.flat
++
// duplication in here (42)!
#[35, 48, 37, 36, 49, 47, 40, 38, 50, 45, 42, 42, 51, 43, 46, 44].collect{|num, i|
	[("red_" ++ i.asStringToBase(10, 2)).asSymbol, (\midiType: \note, \type: \button, \midiChan: 9, \midiNote: num, spec: \midiVel, \mode: \push)]
}.flat
/*++
// left blue is duplicate of red
#[35, 48, 37, 36, 49, 47, 40, 38, 50, 45, 42, 42, 51, 43, 46, 44].collect{|num, i|
	[("red" ++ i.asStringToBase(10, 2)).asSymbol, (\midiType: \note, \type: \button, \midiChan: 9, \midiNote: num, spec: \midiBut, \mode: \push)]
}.flat
*/