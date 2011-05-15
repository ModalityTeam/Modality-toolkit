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
(
scene1: (
	\sl1: (\type: \slider, \chan: 0, \ccNum: 2, \ccKey: '0_2', \spec: \midiCC), 
	\sl2: (\type: \slider, \chan: 0, \ccNum: 3, \ccKey: '0_3', \spec: \midiCC), 
	\sl3: (\type: \slider, \chan: 0, \ccNum: 4, \ccKey: '0_4', \spec: \midiCC), 
	\sl4: (\type: \slider, \chan: 0, \ccNum: 5, \ccKey: '0_5', \spec: \midiCC), 
	\sl5: (\type: \slider, \chan: 0, \ccNum: 6, \ccKey: '0_6', \spec: \midiCC), 
	\sl6: (\type: \slider, \chan: 0, \ccNum: 8, \ccKey: '0_8', \spec: \midiCC), 
	\sl7: (\type: \slider, \chan: 0, \ccNum: 9, \ccKey: '0_9', \spec: \midiCC), 
	\sl8: (\type: \slider, \chan: 0, \ccNum: 12, \ccKey: '0_12', \spec: \midiCC), 
	\sl9: (\type: \slider, \chan: 0, \ccNum: 13, \ccKey: '0_13', \spec: \midiCC), 

	\kn1: (\type: \slider, \chan: 0, \ccNum: 14, \ccKey: '0_14', \spec: \midiCC),
	\kn2: (\type: \slider, \chan: 0, \ccNum: 15, \ccKey: '0_15', \spec: \midiCC),
	\kn3: (\type: \slider, \chan: 0, \ccNum: 16, \ccKey: '0_16', \spec: \midiCC),
	\kn4: (\type: \slider, \chan: 0, \ccNum: 17, \ccKey: '0_17', \spec: \midiCC),
	\kn5: (\type: \slider, \chan: 0, \ccNum: 18, \ccKey: '0_18', \spec: \midiCC),
	\kn6: (\type: \slider, \chan: 0, \ccNum: 19, \ccKey: '0_19', \spec: \midiCC),
	\kn7: (\type: \slider, \chan: 0, \ccNum: 20, \ccKey: '0_20', \spec: \midiCC),
	\kn8: (\type: \slider, \chan: 0, \ccNum: 21, \ccKey: '0_21', \spec: \midiCC),
	\kn9: (\type: \slider, \chan: 0, \ccNum: 22, \ccKey: '0_22', \spec: \midiCC),

	\bu1: (\type: \button, \chan: 0, \ccNum: 23, \ccKey: '0_23', \spec: \midiBut, \mode: \push),
	\bu2: (\type: \button, \chan: 0, \ccNum: 24, \ccKey: '0_24', \spec: \midiBut, \mode: \push),
	\bu3: (\type: \button, \chan: 0, \ccNum: 25, \ccKey: '0_25', \spec: \midiBut, \mode: \push),
	\bu4: (\type: \button, \chan: 0, \ccNum: 26, \ccKey: '0_26', \spec: \midiBut, \mode: \push),
	\bu5: (\type: \button, \chan: 0, \ccNum: 27, \ccKey: '0_27', \spec: \midiBut, \mode: \push),
	\bu6: (\type: \button, \chan: 0, \ccNum: 28, \ccKey: '0_28', \spec: \midiBut, \mode: \push),
	\bu7: (\type: \button, \chan: 0, \ccNum: 29, \ccKey: '0_29', \spec: \midiBut, \mode: \push),
	\bu8: (\type: \button, \chan: 0, \ccNum: 30, \ccKey: '0_30', \spec: \midiBut, \mode: \push),
	\bu9: (\type: \button, \chan: 0, \ccNum: 31, \ccKey: '0_31', \spec: \midiBut, \mode: \push),

	\bd1: (\type: \button, \chan: 0, \ccNum: 33, \ccKey: '0_33', \spec: \midiBut, \mode: \push),
	\bd2: (\type: \button, \chan: 0, \ccNum: 34, \ccKey: '0_34', \spec: \midiBut, \mode: \push),
	\bd3: (\type: \button, \chan: 0, \ccNum: 35, \ccKey: '0_35', \spec: \midiBut, \mode: \push),
	\bd4: (\type: \button, \chan: 0, \ccNum: 36, \ccKey: '0_36', \spec: \midiBut, \mode: \push),
	\bd5: (\type: \button, \chan: 0, \ccNum: 37, \ccKey: '0_37', \spec: \midiBut, \mode: \push),
	\bd6: (\type: \button, \chan: 0, \ccNum: 38, \ccKey: '0_38', \spec: \midiBut, \mode: \push),
	\bd7: (\type: \button, \chan: 0, \ccNum: 39, \ccKey: '0_39', \spec: \midiBut, \mode: \push),
	\bd8: (\type: \button, \chan: 0, \ccNum: 40, \ccKey: '0_40', \spec: \midiBut, \mode: \push),
	\bd9: (\type: \button, \chan: 0, \ccNum: 41, \ccKey: '0_41', \spec: \midiBut, \mode: \push)
), 	
scene2: (), 
scene3: (), 
scene4: (
	\bd1: (\type: \button, \chan: 0, \ccNum: 33, \ccKey: '0_2', 
		\spec: \midiBut, \mode: \toggle
	)
)
)
)

// description of geometric layout for auto-gui? 


