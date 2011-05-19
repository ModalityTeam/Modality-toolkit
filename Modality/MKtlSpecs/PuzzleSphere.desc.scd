// Realplayer Puzzlesphere

Spec.add(\cent1,  [0, 1, \lin, 0, 0.5].asSpec);

[
	// right hand side four labeled buttons
	\btup, (type: \button, osx: (cookie: '?'), linux: (slot: [1,304]), spec: \hidBut, mode: \push), 
	\btdown, (type: \button, osx: (cookie: '?'), linux: (slot: [1,305]), spec: \hidBut, mode: \push), 
	\btright, (type: \button, osx: (cookie: '?'), linux: (slot: [1,306]), spec: \hidBut, mode: \push), 
	\btleft, (type: \button, osx: (cookie: '?'), linux: (slot: [1,307]), spec: \hidBut, mode: \push), 
	\btred, (type: \button, osx: (cookie: '?'), linux: (slot: [1,308]), spec: \hidBut, mode: \push), 
	\btgreen, (type: \button, osx: (cookie: '?'), linux: (slot: [1,309]), spec: \hidBut, mode: \push), 
	
		// joystick axes switches
	\accX, (type: \accelerometer, osx: (cookie: '?', spec: \cent255inv), linux: (slot: [3,0], spec: \cent1 ),  mode: \center), 
	\accY, (type: \accelerometer, osx: (cookie: '?', spec: \cent255 ), linux: (slot: [3,1], spec: \cent1 ),  mode: \center), 
	\accZ, (type: \accelerometer, osx: ( cookie: '?', spec: \cent255inv), linux: (slot: [3,2], spec: \cent1), mode: \center), 
];