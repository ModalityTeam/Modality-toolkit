"Making a description file for a Ktl device:

For every element:
	give it a short name,
		(e.g. slider 1 could be \sl1)
	note how to identify its messages:
		(e.g. for MIDI cc,
			note its chan 0 and cc number 12,
			and possibly its combined ccKey '0_12')
	move it thru all its range,
	note its expected default state,
	write the observed range and default as a spec,
		(e.g. [0, 127, \lin, 1, 0])
	note other things (toggle/push mode)

To discover names and channels and stuff for MIDI devices, connect your device and evaluate the following:"

MIDIIn.connectAll
MIDIFunc.cc({|val, num, chan, src|
	["cc",\val,val,\midiNum, num, \midiChan, chan, \src, src].postln
}); // match all ccs


MIDIFunc.noteOn({|val, num, chan, src|
	["noteOn",\val,val,\midiNum, num, \midiChan, chan, \src, src].postln
}); // match any noteOn

MIDIFunc.noteOff({|val, num, chan, src|
	["noteOff",\val,val,\midiNum, num, \midiChan, chan, \src, src].postln
}); // match any noteOff



	// in the device's state itself:
current state,
	(sl_1: 54, kn_1: 127, bu_7: 0);

MIDIFunc.bend({|val, num, chan, src|
	["bend",\val,val,\midiNum, num, \midiChan, chan, \src, src].postln
}); // match any bend

//A nice trick to get a bunch of midi/cc numbers:

x=[];

MIDIIn.noteOn_({ |a,b,c,d| x = x.add(c.postln) })

Spec.add(\midiCC, [0, 127, \lin, 1, 0]);
Spec.add(\midiVel, [0, 127, \lin, 1, 0]);
Spec.add(\midiBut, [0, 127, \lin, 127, 0]);

	// filename is nanoKONTROL.scd, so device name is nanoKONTROL
[

// the same in all scenes:
	\rew:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 47, \spec: \midiBut, \mode: \push),
	\play: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 45, \spec: \midiBut, \mode: \push),
	\fwd:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 48, \spec: \midiBut, \mode: \push),
	\loop: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 49, \spec: \midiBut, \mode: \push),
	\stop: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 46, \spec: \midiBut, \mode: \push),
	\rec:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 44, \spec: \midiBut, \mode: \push),

// scene1:
	\sl1_1: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  2, \spec: \midiCC),
	\sl2_1: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  3, \spec: \midiCC),
	\sl3_1: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  4, \spec: \midiCC),
	\sl4_1: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  5, \spec: \midiCC),
	\sl5_1: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  6, \spec: \midiCC),
	\sl6_1: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  8, \spec: \midiCC),
	\sl7_1: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  9, \spec: \midiCC),
	\sl8_1: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 12, \spec: \midiCC),
	\sl9_1: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 13, \spec: \midiCC),

	\kn1_1: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 14, \spec: \midiCC),
	\kn2_1: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 15, \spec: \midiCC),
	\kn3_1: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 16, \spec: \midiCC),
	\kn4_1: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 17, \spec: \midiCC),
	\kn5_1: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 18, \spec: \midiCC),
	\kn6_1: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 19, \spec: \midiCC),
	\kn7_1: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 20, \spec: \midiCC),
	\kn8_1: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 21, \spec: \midiCC),
	\kn9_1: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 22, \spec: \midiCC),

	\bu1_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 23, \spec: \midiBut, \mode: \push),
	\bu2_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 24, \spec: \midiBut, \mode: \push),
	\bu3_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 25, \spec: \midiBut, \mode: \push),
	\bu4_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 26, \spec: \midiBut, \mode: \push),
	\bu5_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 27, \spec: \midiBut, \mode: \push),
	\bu6_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 28, \spec: \midiBut, \mode: \push),
	\bu7_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 29, \spec: \midiBut, \mode: \push),
	\bu8_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 30, \spec: \midiBut, \mode: \push),
	\bu9_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 31, \spec: \midiBut, \mode: \push),

	\bd1_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 33, \spec: \midiBut, \mode: \push),
	\bd2_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 34, \spec: \midiBut, \mode: \push),
	\bd3_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 35, \spec: \midiBut, \mode: \push),
	\bd4_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 36, \spec: \midiBut, \mode: \push),
	\bd5_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 37, \spec: \midiBut, \mode: \push),
	\bd6_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 38, \spec: \midiBut, \mode: \push),
	\bd7_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 39, \spec: \midiBut, \mode: \push),
	\bd8_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 40, \spec: \midiBut, \mode: \push),
	\bd9_1: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 41, \spec: \midiBut, \mode: \push),

// scene2:
	\sl1_2:  (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 42, \spec: \midiCC),
	\sl2_2:  (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 43, \spec: \midiCC),
	\sl3_2:  (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 50, \spec: \midiCC),
	\sl4_2:  (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 51, \spec: \midiCC),
	\sl5_2:  (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 52, \spec: \midiCC),
	\sl6_2:  (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 53, \spec: \midiCC),
	\sl7_2:  (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 54, \spec: \midiCC),
	\sl8_2:  (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 55, \spec: \midiCC),
	\sl9_2:  (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 56, \spec: \midiCC),

	\kn1_2:  (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 57, \spec: \midiCC),
	\kn2_2:  (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 58, \spec: \midiCC),
	\kn3_2:  (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 59, \spec: \midiCC),
	\kn4_2:  (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 60, \spec: \midiCC),
	\kn5_2:  (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 61, \spec: \midiCC),
	\kn6_2:  (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 62, \spec: \midiCC),
	\kn7_2:  (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 63, \spec: \midiCC),
	\kn8_2:  (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 65, \spec: \midiCC),
	\kn9_2:  (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 66, \spec: \midiCC),

	\bu1_2:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 67, \spec: \midiBut, \mode: \push),
	\bu2_2:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 68, \spec: \midiBut, \mode: \push),
	\bu3_2:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 69, \spec: \midiBut, \mode: \push),
	\bu4_2:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 70, \spec: \midiBut, \mode: \push),
	\bu5_2:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 71, \spec: \midiBut, \mode: \push),
	\bu6_2:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 72, \spec: \midiBut, \mode: \push),
	\bu7_2:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 73, \spec: \midiBut, \mode: \push),
	\bu8_2:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 74, \spec: \midiBut, \mode: \push),
	\bu9_2:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 75, \spec: \midiBut, \mode: \push),

	\bd1_2:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 76, \spec: \midiBut, \mode: \push),
	\bd2_2:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 77, \spec: \midiBut, \mode: \push),
	\bd3_2:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 78, \spec: \midiBut, \mode: \push),
	\bd4_2:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 79, \spec: \midiBut, \mode: \push),
	\bd5_2:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 80, \spec: \midiBut, \mode: \push),
	\bd6_2:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 81, \spec: \midiBut, \mode: \push),
	\bd7_2:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 82, \spec: \midiBut, \mode: \push),
	\bd8_2:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 83, \spec: \midiBut, \mode: \push),
	\bd9_2:  (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 84, \spec: \midiBut, \mode: \push),

// scene3:
	\sl1_3: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  85, \spec: \midiCC),
	\sl2_3: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  86, \spec: \midiCC),
	\sl3_3: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  87, \spec: \midiCC),
	\sl4_3: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  88, \spec: \midiCC),
	\sl5_3: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  89, \spec: \midiCC),
	\sl6_3: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  90, \spec: \midiCC),
	\sl7_3: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  91, \spec: \midiCC),
	\sl8_3: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  92, \spec: \midiCC),
	\sl9_3: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  93, \spec: \midiCC),

	\kn1_3: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  94, \spec: \midiCC),
	\kn2_3: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  95, \spec: \midiCC),
	\kn3_3: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  96, \spec: \midiCC),
	\kn4_3: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  97, \spec: \midiCC),
	\kn5_3: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 102, \spec: \midiCC),
	\kn6_3: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 103, \spec: \midiCC),
	\kn7_3: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 104, \spec: \midiCC),
	\kn8_3: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 105, \spec: \midiCC),
	\kn9_3: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum: 106, \spec: \midiCC),

	\bu1_3: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 107, \spec: \midiBut, \mode: \push),
	\bu2_3: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 108, \spec: \midiBut, \mode: \push),
	\bu3_3: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 109, \spec: \midiBut, \mode: \push),
	\bu4_3: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 110, \spec: \midiBut, \mode: \push),
	\bu5_3: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 111, \spec: \midiBut, \mode: \push),
	\bu6_3: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 112, \spec: \midiBut, \mode: \push),
	\bu7_3: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 113, \spec: \midiBut, \mode: \push),
	\bu8_3: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 114, \spec: \midiBut, \mode: \push),
	\bu9_3: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 115, \spec: \midiBut, \mode: \push),

	\bd1_3: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 116, \spec: \midiBut, \mode: \push),
	\bd2_3: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 117, \spec: \midiBut, \mode: \push),
	\bd3_3: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 118, \spec: \midiBut, \mode: \push),
	\bd4_3: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 119, \spec: \midiBut, \mode: \push),
	\bd5_3: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 120, \spec: \midiBut, \mode: \push),
	\bd6_3: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 121, \spec: \midiBut, \mode: \push),
	\bd7_3: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 122, \spec: \midiBut, \mode: \push),
	\bd8_3: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 123, \spec: \midiBut, \mode: \push),
	\bd9_3: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 124, \spec: \midiBut, \mode: \push),

// scene4:

	\sl1_4: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:   7, \spec: \midiCC),
	\sl2_4: (\midiType: \cc, \type: \slider, \midiChan: 1, \midiNum:   7, \spec: \midiCC),
	\sl3_4: (\midiType: \cc, \type: \slider, \midiChan: 2, \midiNum:   7, \spec: \midiCC),
	\sl4_4: (\midiType: \cc, \type: \slider, \midiChan: 3, \midiNum:   7, \spec: \midiCC),
	\sl5_4: (\midiType: \cc, \type: \slider, \midiChan: 4, \midiNum:   7, \spec: \midiCC),
	\sl6_4: (\midiType: \cc, \type: \slider, \midiChan: 5, \midiNum:   7, \spec: \midiCC),
	\sl7_4: (\midiType: \cc, \type: \slider, \midiChan: 6, \midiNum:   7, \spec: \midiCC),
	\sl8_4: (\midiType: \cc, \type: \slider, \midiChan: 7, \midiNum:   7, \spec: \midiCC),
	\sl9_4: (\midiType: \cc, \type: \slider, \midiChan: 8, \midiNum:   7, \spec: \midiCC),

	\kn1_4: (\midiType: \cc, \type: \slider, \midiChan: 0, \midiNum:  10, \spec: \midiCC),
	\kn2_4: (\midiType: \cc, \type: \slider, \midiChan: 1, \midiNum:  10, \spec: \midiCC),
	\kn3_4: (\midiType: \cc, \type: \slider, \midiChan: 2, \midiNum:  10, \spec: \midiCC),
	\kn4_4: (\midiType: \cc, \type: \slider, \midiChan: 3, \midiNum:  10, \spec: \midiCC),
	\kn5_4: (\midiType: \cc, \type: \slider, \midiChan: 4, \midiNum:  10, \spec: \midiCC),
	\kn6_4: (\midiType: \cc, \type: \slider, \midiChan: 5, \midiNum:  10, \spec: \midiCC),
	\kn7_4: (\midiType: \cc, \type: \slider, \midiChan: 6, \midiNum:  10, \spec: \midiCC),
	\kn8_4: (\midiType: \cc, \type: \slider, \midiChan: 7, \midiNum:  10, \spec: \midiCC),
	\kn9_4: (\midiType: \cc, \type: \slider, \midiChan: 8, \midiNum:  10, \spec: \midiCC),

	\bu1_4: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 16, \spec: \midiBut, \mode: \toggle),
	\bu2_4: (\midiType: \cc, \type: \button, \midiChan: 1, \midiNum: 16, \spec: \midiBut, \mode: \toggle),
	\bu3_4: (\midiType: \cc, \type: \button, \midiChan: 2, \midiNum: 16, \spec: \midiBut, \mode: \toggle),
	\bu4_4: (\midiType: \cc, \type: \button, \midiChan: 3, \midiNum: 16, \spec: \midiBut, \mode: \toggle),
	\bu5_4: (\midiType: \cc, \type: \button, \midiChan: 4, \midiNum: 16, \spec: \midiBut, \mode: \toggle),
	\bu6_4: (\midiType: \cc, \type: \button, \midiChan: 5, \midiNum: 16, \spec: \midiBut, \mode: \toggle),
	\bu7_4: (\midiType: \cc, \type: \button, \midiChan: 6, \midiNum: 16, \spec: \midiBut, \mode: \toggle),
	\bu8_4: (\midiType: \cc, \type: \button, \midiChan: 7, \midiNum: 16, \spec: \midiBut, \mode: \toggle),
	\bu9_4: (\midiType: \cc, \type: \button, \midiChan: 8, \midiNum: 16, \spec: \midiBut, \mode: \toggle),

	\bd1_4: (\midiType: \cc, \type: \button, \midiChan: 0, \midiNum: 17, \spec: \midiBut, \mode: \toggle),
	\bd2_4: (\midiType: \cc, \type: \button, \midiChan: 1, \midiNum: 17, \spec: \midiBut, \mode: \toggle),
	\bd3_4: (\midiType: \cc, \type: \button, \midiChan: 2, \midiNum: 17, \spec: \midiBut, \mode: \toggle),
	\bd4_4: (\midiType: \cc, \type: \button, \midiChan: 3, \midiNum: 17, \spec: \midiBut, \mode: \toggle),
	\bd5_4: (\midiType: \cc, \type: \button, \midiChan: 4, \midiNum: 17, \spec: \midiBut, \mode: \toggle),
	\bd6_4: (\midiType: \cc, \type: \button, \midiChan: 5, \midiNum: 17, \spec: \midiBut, \mode: \toggle),
	\bd7_4: (\midiType: \cc, \type: \button, \midiChan: 6, \midiNum: 17, \spec: \midiBut, \mode: \toggle),
	\bd8_4: (\midiType: \cc, \type: \button, \midiChan: 7, \midiNum: 17, \spec: \midiBut, \mode: \toggle),
	\bd9_4: (\midiType: \cc, \type: \button, \midiChan: 8, \midiNum: 17, \spec: \midiBut, \mode: \toggle)

]
// description of geometric layout for auto-gui?







/* can we enumerate all the variations of keys?

* Global
\type
	\button
	\slider
    \pad

\spec
	\something	 * symbol of an existing Spec
	\anything		 * symbol of another existing Spec

	\hidBut
	\midiBut

\mode
	\push
	\toggle

* protocol dependant

	* HID
		\cookie

	* MIDI
		\midiChan

		\midiType
			\cc
				\midiNum
			\noteOn
				\midiNote
			\noteOff
				\midiNote
			\sysex
				\sysexNum
			\touch
				\touchNum
			\polytouch
				\polytouchNum
			\breath
				\breathNum
			\bend
				\midiNum
			\program
				\programNum
			\sysrt
				\sysrtNum
			\smpte
				\smpteNum



*/


//MIDIIn




