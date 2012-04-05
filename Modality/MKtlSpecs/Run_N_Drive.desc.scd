// Thrustmaster run'n'drive, designed by Ferrari, limited edition

[
	// no idea what this is
// [ Collection, GamePad, 1, 0, 0, 513, 1, 5 ]

	// right hand side four labeled buttons
	\bt_R_1, (type: \button, osx: (cookie: 2), linux: (slot: [1,304]), spec: \hidBut, mode: \push),
	\bt_R_2, (type: \button, osx: (cookie: 3), linux: (slot: [1,305]), spec: \hidBut, mode: \push),
	\bt_R_3, (type: \button, osx: (cookie: 4), linux: (slot: [1,306]), spec: \hidBut, mode: \push),
	\bt_R_4, (type: \button, osx: (cookie: 5), linux: (slot: [1,307]), spec: \hidBut, mode: \push),
	
		// left shoulder fire button, right shoulder fire button, 
		// left bottom fire button,  right bottom fire button, 
 	\lfTop_1, (type: \button, osx: (cookie: 6), linux: (slot: [1,308]), spec: \hidBut, mode: \push),
	\lfTop_2, (type: \button, osx: (cookie: 7), linux: (slot: [1,309]), spec: \hidBut, mode: \push),
	\lfTop_3, (type: \button, osx: (cookie: 8), linux: (slot: [1,310]), spec: \hidBut, mode: \push),
	\lfTop_4, (type: \button, osx: (cookie: 9), linux: (slot: [1,311]), spec: \hidBut, mode: \push),
		
		// middle buttons
 	\mid_L, (type: \button, osx: (cookie: 10), linux: (slot: [1,312]), spec: \hidBut, mode: \push),
	\mid_R, (type: \button, osx: (cookie: 11), linux: (slot: [1,313]), spec: \hidBut, mode: \push),
	
		// joystick hat switches
	\joyHat_L, (type: \hidHat, osx: (cookie: 12), linux: (slot: [1,314]), spec: \hidHat, mode: \center),
	\joyHat_R, (type: \hidHat, osx: (cookie: 13), linux: (slot: [1,315]), spec: \hidHat, mode: \center),

		// joystick axes switches
	\joy_L_X, (type: \joyAxis, osx: (cookie: 15, spec: \cent255inv), linux: (slot: [3,0], spec: \cent1 ),  mode: \center),
	\joy_L_Y, (type: \joyAxis, osx: (cookie: 16, spec: \cent255 ), linux: (slot: [3,1], spec: \cent1 ),  mode: \center),
	\joy_R_X, (type: \joyAxis, osx: ( cookie: 17, spec: \cent255inv), linux: (slot: [3,2], spec: \cent1), mode: \center),
	\joy_R_Y, (type: \joyAxis, osx: ( cookie: 20, spec: \cent255 ), linux: ( slot: [3,5], spec: \cent1 ), mode: \center),

	// what is meant with mode "minimum", on Linux it seems more logical to just inverse the spec
	\throt_L, (type: \springFader, osx: (cookie: 17, spec: \lin255 ), linux: (slot: [3,3], spec: \lin1inv ), mode: \minimum),
	\throt_R, (type: \springFader, osx: (cookie: 20, spec: \lin255 ), linux: (slot: [3,4], spec: \lin1inv ), mode: \minimum),
	
		// west is 1, south is 3, east is 5, north is 7
	\compass, (type: \compass, osx: (cookie: 14, spec: \compass8), mode: \push),	
		// added osx specs for compassX, Y to avoid warning; not sure it is a good idea. 
		// maybe some way of labeling whether an element shows up on linux or osx only? 
		// e.g. if no spec the platform is not there, swallow it.
	\compass_X, (type: \compassX, osx: (cookie: 14, spec: \compass8), linux: (slot: [3,16], spec: \cent1inv), mode: \push),
	\compass_Y, (type: \compassY, osx: (cookie: 14, spec: \compass8), linux: (slot: [3,17], spec: \cent1inv), mode: \push),
	
	\wheel, (type: \springFader, osx: (cookie: 21, spec: \cent255), linux: (slot: [3,6], spec: \cent1inv), mode: \center)
];