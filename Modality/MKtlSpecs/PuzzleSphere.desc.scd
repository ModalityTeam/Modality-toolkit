// Realplayer Puzzlesphere

Spec.add(\cent1,  [0, 1, \lin, 0, 0.5].asSpec);

[
	// right hand side four labeled buttons
	\bt_up, (type: \button, osx: (cookie: '?'), linux: (slot: [1,304]), spec: \hidBut, mode: \push),
	\bt_down, (type: \button, osx: (cookie: '?'), linux: (slot: [1,305]), spec: \hidBut, mode: \push),
	\bt_right, (type: \button, osx: (cookie: '?'), linux: (slot: [1,306]), spec: \hidBut, mode: \push),
	\bt_left, (type: \button, osx: (cookie: '?'), linux: (slot: [1,307]), spec: \hidBut, mode: \push),
	\bt_red, (type: \button, osx: (cookie: '?'), linux: (slot: [1,308]), spec: \hidBut, mode: \push),
	\bt_green, (type: \button, osx: (cookie: '?'), linux: (slot: [1,309]), spec: \hidBut, mode: \push),
	
		// joystick axes switches
	\acc_X, (type: \accelerometer, osx: (cookie: '?', spec: \cent255inv), linux: (slot: [3,0], spec: \cent1 ),  mode: \center),
	\acc_Y, (type: \accelerometer, osx: (cookie: '?', spec: \cent255 ), linux: (slot: [3,1], spec: \cent1 ),  mode: \center),
	\acc_Z, (type: \accelerometer, osx: ( cookie: '?', spec: \cent255inv), linux: (slot: [3,2], spec: \cent1), mode: \center),
];