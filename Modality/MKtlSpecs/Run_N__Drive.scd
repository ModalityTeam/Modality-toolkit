// Thrustmaster run'n'drive, designed by Ferrari, limited edition

[
	// no idea what this is
// [ Collection, GamePad, 1, 0, 0, 513, 1, 5 ]

	// right hand side four labeled buttons
	\bt1r, (type: \button, cookie: 2, \spec: \hidBut, \mode: \push), 
	\bt2r, (type: \button, cookie: 3, \spec: \hidBut, \mode: \push), 
	\bt3r, (type: \button, cookie: 4, \spec: \hidBut, \mode: \push), 
	\bt4r, (type: \button, cookie: 5, \spec: \hidBut, \mode: \push), 
	
		// left shoulder fire button, right shoulder fire button, 
		// left bottom fire button,  right bottom fire button, 
 	\lfTop5, (type: \button, cookie: 6, \spec: \hidBut, \mode: \push), 
	\rfTop6, (type: \button, cookie: 7, \spec: \hidBut, \mode: \push), 
	\lfBot7, (type: \button, cookie: 8, \spec: \hidBut, \mode: \push), 
	\rfBot8, (type: \button, cookie: 9, \spec: \hidBut, \mode: \push), 
		
		// middle buttons
 	\midL9, (type: \button, cookie: 10, \spec: \hidBut, \mode: \push), 
	\midR10, (type: \button, cookie: 11, \spec: \hidBut, \mode: \push), 
	
		// joystick hat switches
	\joyLHat, (type: \hidHat, cookie: 12, \spec: \hidHat, \mode: \center), 
	\joyRHat, (type: \hidHat, cookie: 13, \spec: \hidHat, \mode: \center), 

		// joystick axes switches
	\joyLX, (type: \joyAxis, cookie: 15, \spec: \lin255n, \mode: \center), 
	\joyLY, (type: \joyAxis, cookie: 16, \spec: \lin255, \mode: \center), 
	\joyRX, (type: \joyAxis, cookie: 17, \spec: \lin255n, \mode: \center), 
	\joyRY, (type: \joyAxis, cookie: 20, \spec: \lin255, \mode: \center), 

	\throtL, (type: \springFader, cookie: 17, \spec: \throt, \mode: \minimum), 
	\throtR, (type: \springFader, cookie: 20, \spec: \throt, \mode: \minimum), 
	
		// west is 1, south is 3, east is 5, north is 7
	\compass, (type: \compass, cookie: 14) 	
];