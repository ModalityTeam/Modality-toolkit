/*

MPD18

one slider, sends on chan 1, ccnum, 1, [0, 127, \lin, 1, 0]

channel aftertouch,sends on cahn 0, [0, 127, \lin, 1, 0]

16 pads x 3 banks, pad 1, ... pad 16

// scene
    noteOn , scene A, pad1
k.elementAt(\padOn, 1, 1).addAction({ \boing.postln });
    noteOff , scene B, pad16
k.elementAt(\padOff, 2, 16).addAction({ \letGo.postln });


k = MIDIMKtl.make('MPD','kmpd180');
k = MIDIMKtl('Akai MPD18').elements
k = MIDIMKtl('kmpd180');
k.elements;


*/
(

\sl: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  1, \spec: \midiCC),

	// // ------- touch ------------
'touch_0': ('midiType': 'touch', 'type': 'chantouch', 'midiChan': 0, 'midiNote':  0,'spec': 'midiTouch'),

\padOn: (36..83).clump(16).collect{ |padNums|
	padNums.collect {|padNum| (\midiType: \noteOn, \type: \pad, midiChan: 0,
		\midiNum: padNum, \spec: \midiNote) }
},
\padOff: (36..83).clump(16).collect{ |padNums|
	padNums.collect {|padNum| (\midiType: \noteOff, \type: \pad, midiChan: 0,
		\midiNum: padNum, \spec: \midiNote) }
}
);