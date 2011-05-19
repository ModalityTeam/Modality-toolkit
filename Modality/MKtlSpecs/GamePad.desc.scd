// template GamePad description

Spec.add(\cent1,  [0, 1, \lin, 0, 0.5].asSpec);

[
	// no idea what this is
// [ Collection, GamePad, 1, 0, 0, 513, 1, 5 ]

	// right hand side four labeled buttons
	\bt1r, (type: \button, osx: (cookie: '?'), linux: (slot: [1,'?']), spec: \hidBut, mode: \push), 
	\bt2r, (type: \button, osx: (cookie: '?'), linux: (slot: [1,'?']), spec: \hidBut, mode: \push), 
	\bt3r, (type: \button, osx: (cookie: '?'), linux: (slot: [1,'?']), spec: \hidBut, mode: \push), 
	\bt4r, (type: \button, osx: (cookie: '?'), linux: (slot: [1,'?']), spec: \hidBut, mode: \push), 
	
		// left shoulder fire button, right shoulder fire button, 
		// left bottom fire button,  right bottom fire button, 
 	\lfTop5, (type: \button, osx: (cookie: '?'), linux: (slot: [1,'?']), spec: \hidBut, mode: \push), 
	\lfBot6, (type: \button, osx: (cookie: '?'), linux: (slot: [1,'?']), spec: \hidBut, mode: \push), 
	\rfTop7, (type: \button, osx: (cookie: '?'), linux: (slot: [1,'?']), spec: \hidBut, mode: \push), 
	\rfBot8, (type: \button, osx: (cookie: '?'), linux: (slot: [1,'?']), spec: \hidBut, mode: \push), 
		
		// middle buttons
 	\midL9, (type: \button, osx: (cookie: '?'), linux: (slot: [1,'?']), spec: \hidBut, mode: \push), 
	\midR10, (type: \button, osx: (cookie: '?'), linux: (slot: [1,'?']), spec: \hidBut, mode: \push), 
	
		// joystick hat switches
	\joyLHat, (type: \hidHat, osx: (cookie: '?'), linux: (slot: [1,'?']), spec: \hidHat, mode: \center), 
	\joyRHat, (type: \hidHat, osx: (cookie: '?'), linux: (slot: [1,'?']), spec: \hidHat, mode: \center), 

		// joystick axes switches
	\joyLX, (type: \joyAxis, osx: (cookie: '?', spec: \cent255inv), linux: (slot: [3,1], spec: \cent1 ),  mode: \center), 
	\joyLY, (type: \joyAxis, osx: (cookie: '?', spec: \cent255 ), linux: (slot: [3,0], spec: \cent1 ),  mode: \center), 
	\joyRX, (type: \joyAxis, osx: ( cookie: '?', spec: \cent255inv), linux: (slot: [3,5], spec: \cent1), mode: \center), 
	\joyRY, (type: \joyAxis, osx: ( cookie: '?', spec: \cent255 ), linux: ( slot: [3,2], spec: \cent1 ), mode: \center), 
	
		// west is 1, south is 3, east is 5, north is 7
	\compass, (type: \compass, osx: (cookie: '?', spec: \compass8), mode: \push),	
	\compassX, (type: \compassX, linux: (slot: [3,16], spec: \cent1), mode: \push),	
	\compassY, (type: \compassY, linux: (slot: [3,17], spec: \cent1), mode: \push),	
];