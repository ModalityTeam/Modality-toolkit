Making a description file for a Ktl device:

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


	// in the device's state itself: 
current state, 
	(sl1: 54, kn1: 127, bu7: 0); 
current scene (if known)


Spec.add(\midiCC, [0, 127, \lin, 1, 0]); 
Spec.add(\midiVel, [0, 127, \lin, 1, 0]); 
Spec.add(\midiBut, [0, 127, \lin, 127, 0]); 

	// filename is nanoKONTROL.scd, so device name is nanoKONTROL
[

// the same in all scenes: 
	\rew:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 47, \spec: \midiBut, \mode: \push),
	\play: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 45, \spec: \midiBut, \mode: \push),
	\fwd:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 48, \spec: \midiBut, \mode: \push),
	\loop: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 49, \spec: \midiBut, \mode: \push),
	\stop: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 46, \spec: \midiBut, \mode: \push),
	\rec:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 44, \spec: \midiBut, \mode: \push),

// scene1: 
	\sl1_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  2, \spec: \midiCC), 
	\sl2_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  3, \spec: \midiCC), 
	\sl3_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  4, \spec: \midiCC), 
	\sl4_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  5, \spec: \midiCC), 
	\sl5_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  6, \spec: \midiCC), 
	\sl6_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  8, \spec: \midiCC), 
	\sl7_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  9, \spec: \midiCC), 
	\sl8_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 12, \spec: \midiCC), 
	\sl9_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 13, \spec: \midiCC), 

	\kn1_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 14, \spec: \midiCC),
	\kn2_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 15, \spec: \midiCC),
	\kn3_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 16, \spec: \midiCC),
	\kn4_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 17, \spec: \midiCC),
	\kn5_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 18, \spec: \midiCC),
	\kn6_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 19, \spec: \midiCC),
	\kn7_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 20, \spec: \midiCC),
	\kn8_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 21, \spec: \midiCC),
	\kn9_1: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 22, \spec: \midiCC),

	\bu1_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 23, \spec: \midiBut, \mode: \push),
	\bu2_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 24, \spec: \midiBut, \mode: \push),
	\bu3_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 25, \spec: \midiBut, \mode: \push),
	\bu4_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 26, \spec: \midiBut, \mode: \push),
	\bu5_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 27, \spec: \midiBut, \mode: \push),
	\bu6_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 28, \spec: \midiBut, \mode: \push),
	\bu7_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 29, \spec: \midiBut, \mode: \push),
	\bu8_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 30, \spec: \midiBut, \mode: \push),
	\bu9_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 31, \spec: \midiBut, \mode: \push),

	\bd1_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 33, \spec: \midiBut, \mode: \push),
	\bd2_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 34, \spec: \midiBut, \mode: \push),
	\bd3_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 35, \spec: \midiBut, \mode: \push),
	\bd4_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 36, \spec: \midiBut, \mode: \push),
	\bd5_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 37, \spec: \midiBut, \mode: \push),
	\bd6_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 38, \spec: \midiBut, \mode: \push),
	\bd7_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 39, \spec: \midiBut, \mode: \push),
	\bd8_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 40, \spec: \midiBut, \mode: \push),
	\bd9_1: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 41, \spec: \midiBut, \mode: \push),

// scene2:
	\sl1_2:  (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 42, \spec: \midiCC), 
	\sl2_2:  (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 43, \spec: \midiCC), 
	\sl3_2:  (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 50, \spec: \midiCC), 
	\sl4_2:  (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 51, \spec: \midiCC), 
	\sl5_2:  (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 52, \spec: \midiCC), 
	\sl6_2:  (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 53, \spec: \midiCC), 
	\sl7_2:  (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 54, \spec: \midiCC), 
	\sl8_2:  (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 55, \spec: \midiCC), 
	\sl9_2:  (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 56, \spec: \midiCC), 

	\kn1_2:  (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 57, \spec: \midiCC),
	\kn2_2:  (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 58, \spec: \midiCC),
	\kn3_2:  (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 59, \spec: \midiCC),
	\kn4_2:  (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 60, \spec: \midiCC),
	\kn5_2:  (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 61, \spec: \midiCC),
	\kn6_2:  (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 62, \spec: \midiCC),
	\kn7_2:  (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 63, \spec: \midiCC),
	\kn8_2:  (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 65, \spec: \midiCC),
	\kn9_2:  (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 66, \spec: \midiCC),

	\bu1_2:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 67, \spec: \midiBut, \mode: \push),
	\bu2_2:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 68, \spec: \midiBut, \mode: \push),
	\bu3_2:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 69, \spec: \midiBut, \mode: \push),
	\bu4_2:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 70, \spec: \midiBut, \mode: \push),
	\bu5_2:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 71, \spec: \midiBut, \mode: \push),
	\bu6_2:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 72, \spec: \midiBut, \mode: \push),
	\bu7_2:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 73, \spec: \midiBut, \mode: \push),
	\bu8_2:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 74, \spec: \midiBut, \mode: \push),
	\bu9_2:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 75, \spec: \midiBut, \mode: \push),

	\bd1_2:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 76, \spec: \midiBut, \mode: \push),
	\bd2_2:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 77, \spec: \midiBut, \mode: \push),
	\bd3_2:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 78, \spec: \midiBut, \mode: \push),
	\bd4_2:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 79, \spec: \midiBut, \mode: \push),
	\bd5_2:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 80, \spec: \midiBut, \mode: \push),
	\bd6_2:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 81, \spec: \midiBut, \mode: \push),
	\bd7_2:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 82, \spec: \midiBut, \mode: \push),
	\bd8_2:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 83, \spec: \midiBut, \mode: \push),
	\bd9_2:  (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 84, \spec: \midiBut, \mode: \push),
	
// scene3: 
	\sl1_3: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  85, \spec: \midiCC), 
	\sl2_3: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  86, \spec: \midiCC), 
	\sl3_3: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  87, \spec: \midiCC), 
	\sl4_3: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  88, \spec: \midiCC), 
	\sl5_3: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  89, \spec: \midiCC), 
	\sl6_3: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  90, \spec: \midiCC), 
	\sl7_3: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  91, \spec: \midiCC), 
	\sl8_3: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  92, \spec: \midiCC), 
	\sl9_3: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  93, \spec: \midiCC), 

	\kn1_3: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  94, \spec: \midiCC),
	\kn2_3: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  95, \spec: \midiCC),
	\kn3_3: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  96, \spec: \midiCC),
	\kn4_3: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  97, \spec: \midiCC),
	\kn5_3: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 102, \spec: \midiCC),
	\kn6_3: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 103, \spec: \midiCC),
	\kn7_3: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 104, \spec: \midiCC),
	\kn8_3: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 105, \spec: \midiCC),
	\kn9_3: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum: 106, \spec: \midiCC),

	\bu1_3: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 107, \spec: \midiBut, \mode: \push),
	\bu2_3: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 108, \spec: \midiBut, \mode: \push),
	\bu3_3: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 109, \spec: \midiBut, \mode: \push),
	\bu4_3: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 110, \spec: \midiBut, \mode: \push),
	\bu5_3: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 111, \spec: \midiBut, \mode: \push),
	\bu6_3: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 112, \spec: \midiBut, \mode: \push),
	\bu7_3: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 113, \spec: \midiBut, \mode: \push),
	\bu8_3: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 114, \spec: \midiBut, \mode: \push),
	\bu9_3: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 115, \spec: \midiBut, \mode: \push),

	\bd1_3: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 116, \spec: \midiBut, \mode: \push),
	\bd2_3: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 117, \spec: \midiBut, \mode: \push),
	\bd3_3: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 118, \spec: \midiBut, \mode: \push),
	\bd4_3: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 119, \spec: \midiBut, \mode: \push),
	\bd5_3: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 120, \spec: \midiBut, \mode: \push),
	\bd6_3: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 121, \spec: \midiBut, \mode: \push),
	\bd7_3: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 122, \spec: \midiBut, \mode: \push),
	\bd8_3: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 123, \spec: \midiBut, \mode: \push),
	\bd9_3: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 124, \spec: \midiBut, \mode: \push),
 	
// scene4: 

	\sl1_4: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:   7, \spec: \midiCC), 
	\sl2_4: (\midiType: \cc, \type: \slider, \chan: 1, \ccNum:   7, \spec: \midiCC), 
	\sl3_4: (\midiType: \cc, \type: \slider, \chan: 2, \ccNum:   7, \spec: \midiCC), 
	\sl4_4: (\midiType: \cc, \type: \slider, \chan: 3, \ccNum:   7, \spec: \midiCC), 
	\sl5_4: (\midiType: \cc, \type: \slider, \chan: 4, \ccNum:   7, \spec: \midiCC), 
	\sl6_4: (\midiType: \cc, \type: \slider, \chan: 5, \ccNum:   7, \spec: \midiCC), 
	\sl7_4: (\midiType: \cc, \type: \slider, \chan: 6, \ccNum:   7, \spec: \midiCC), 
	\sl8_4: (\midiType: \cc, \type: \slider, \chan: 7, \ccNum:   7, \spec: \midiCC), 
	\sl9_4: (\midiType: \cc, \type: \slider, \chan: 8, \ccNum:   7, \spec: \midiCC), 

	\kn1_4: (\midiType: \cc, \type: \slider, \chan: 0, \ccNum:  10, \spec: \midiCC),
	\kn2_4: (\midiType: \cc, \type: \slider, \chan: 1, \ccNum:  10, \spec: \midiCC),
	\kn3_4: (\midiType: \cc, \type: \slider, \chan: 2, \ccNum:  10, \spec: \midiCC),
	\kn4_4: (\midiType: \cc, \type: \slider, \chan: 3, \ccNum:  10, \spec: \midiCC),
	\kn5_4: (\midiType: \cc, \type: \slider, \chan: 4, \ccNum:  10, \spec: \midiCC),
	\kn6_4: (\midiType: \cc, \type: \slider, \chan: 5, \ccNum:  10, \spec: \midiCC),
	\kn7_4: (\midiType: \cc, \type: \slider, \chan: 6, \ccNum:  10, \spec: \midiCC),
	\kn8_4: (\midiType: \cc, \type: \slider, \chan: 7, \ccNum:  10, \spec: \midiCC),
	\kn9_4: (\midiType: \cc, \type: \slider, \chan: 8, \ccNum:  10, \spec: \midiCC),

	\bu1_4: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 16, \spec: \midiBut, \mode: \toggle),
	\bu2_4: (\midiType: \cc, \type: \button, \chan: 1, \ccNum: 16, \spec: \midiBut, \mode: \toggle),
	\bu3_4: (\midiType: \cc, \type: \button, \chan: 2, \ccNum: 16, \spec: \midiBut, \mode: \toggle),
	\bu4_4: (\midiType: \cc, \type: \button, \chan: 3, \ccNum: 16, \spec: \midiBut, \mode: \toggle),
	\bu5_4: (\midiType: \cc, \type: \button, \chan: 4, \ccNum: 16, \spec: \midiBut, \mode: \toggle),
	\bu6_4: (\midiType: \cc, \type: \button, \chan: 5, \ccNum: 16, \spec: \midiBut, \mode: \toggle),
	\bu7_4: (\midiType: \cc, \type: \button, \chan: 6, \ccNum: 16, \spec: \midiBut, \mode: \toggle),
	\bu8_4: (\midiType: \cc, \type: \button, \chan: 7, \ccNum: 16, \spec: \midiBut, \mode: \toggle),
	\bu9_4: (\midiType: \cc, \type: \button, \chan: 8, \ccNum: 16, \spec: \midiBut, \mode: \toggle),

	\bd1_4: (\midiType: \cc, \type: \button, \chan: 0, \ccNum: 17, \spec: \midiBut, \mode: \toggle),
	\bd2_4: (\midiType: \cc, \type: \button, \chan: 1, \ccNum: 17, \spec: \midiBut, \mode: \toggle),
	\bd3_4: (\midiType: \cc, \type: \button, \chan: 2, \ccNum: 17, \spec: \midiBut, \mode: \toggle),
	\bd4_4: (\midiType: \cc, \type: \button, \chan: 3, \ccNum: 17, \spec: \midiBut, \mode: \toggle),
	\bd5_4: (\midiType: \cc, \type: \button, \chan: 4, \ccNum: 17, \spec: \midiBut, \mode: \toggle),
	\bd6_4: (\midiType: \cc, \type: \button, \chan: 5, \ccNum: 17, \spec: \midiBut, \mode: \toggle),
	\bd7_4: (\midiType: \cc, \type: \button, \chan: 6, \ccNum: 17, \spec: \midiBut, \mode: \toggle),
	\bd8_4: (\midiType: \cc, \type: \button, \chan: 7, \ccNum: 17, \spec: \midiBut, \mode: \toggle),
	\bd9_4: (\midiType: \cc, \type: \button, \chan: 8, \ccNum: 17, \spec: \midiBut, \mode: \toggle)

]
// description of geometric layout for auto-gui? 







/* can we enumerate all the variations of keys?

* Global
\type
	\button
	\slider

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
		\chan
		
		\midiType
			\cc
				\ccNum
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
				\bendNum
			\program
				\programNum
			\sysrt
				\sysrtNum
			\smpte
				\smpteNum

	

*/


MIDIIn




