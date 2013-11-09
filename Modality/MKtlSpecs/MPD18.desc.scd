/*

MPD18

slider
chan 1, num, 1, [0, 127, \lin, 1, 0]

16 pads (3 banks)
\bu0_36: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 36, \spec: \midiBut, \mode: \push),

16.do({ |ii| ii = ii + 68;  ("\\bu0_" ++ ii ++ ": (\\midiType: \\cc, \\type: \\button, \\chan: 0, \\ccNum: " ++ ii ++ ", \\spec: \\midiBut, \\mode: \\push),").postln })

MIDIMKtl.find

k = MIDIMKtl.make('MPD','kmpd180');
k = MIDIMKtl('Akai MPD18').elements
k = MIDIMKtl('kmpd180', -1901746588, 1991991596);
*/
[

\sl1_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  1, \spec: \midiCC),

	// // ------- touch ------------
'touch_0': ('midiType': 'touch', 'type': 'chantouch', 'chan': 0, 'midiNote':  0,'spec': 'midiTouch'),

	'note': (\midiType: \noteOnOff, \type: \pad, \chan: 0, \ccNum: (36..83), \spec: \midiNote)

]