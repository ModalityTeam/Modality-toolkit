// M-audio Trigger finger - MKtl
// pads * 16
// [35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51]

// sliders * 4
// [7, 1, 71, 74]

// knobs * 8
// [10, 91, 12, 93, 5, 73, 84, 72]




// BUTTONS :
(1..16).collect{ |it,i|
 [ (\bt_P_++it).asSymbol, ( type: \pad, spec: \midiVel, \midiMsgType: \note, \midiChan: 0, \midiNum: 35 + i ) ];
}.flatten
++
// SLIDERS :
[7, 1, 71, 74].collect{ |it,i|
 [ (\sl_F_++(i+1) ).asSymbol, ( type: \slider, spec: \midiCC, \midiMsgType: \cc, \midiChan: 0, \midiNum: it ) ];

}.flatten
++
// KNOBS :
[10, 91, 12, 93, 5, 73, 84, 72].collect{ |it,i|
 [ (\kn_C_++(i+1)).asSymbol, ( type: \knob, spec: \midiCC, \midiMsgType: \cc, \midiChan: 0, \midiNum: it ) ];

}.flatten;