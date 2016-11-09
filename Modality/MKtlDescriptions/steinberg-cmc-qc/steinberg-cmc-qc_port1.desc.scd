/*
To Do:

* study manual how hardware mode switching works ...

* element descriptions seem right,
  but element responders are not activated correctly ...
  no trace, no action, though MIDIFunc trace posts them fine.


thisProcess.nowExecutingPath.postcs.load;

MIDIFunc.trace;

MKtlDesc.loadDescs("steinberg-cmc*");
m.free; m = MKtl('qc_1', "*qc_port1"); m.gui;
m.postElements;
m.trace;

*/
(
parentDesc: "steinberg-cmc-qc",

status: (
	linux: "unknown",
	osx: "tested, elements. 2016-03-16, adc",
	win: "unknown"),

idInfo: (deviceName: "Steinberg CMC-QC", srcPortIndex: 0, destPortIndex: 0),

elementsDesc: (
	elements: [
		// active after bt EQ1, 2, 3 was pressed
		(
			key: \knRel,
			shared: ('midiMsgType': 'control', 'elementType': 'knob', 'midiChan':  0, 'spec': 'midiCC'),
			elements: (16..23).collect { |ccnum, i|
				('midiNum': ccnum, style: (row: i div: 4, column: i % 4 ))
			}
		),
		// // active after bt MIDI was pressed
		// (
		// 	key: \kn,
		// 	shared: ('midiMsgType': 'cc', 'elementType': 'knob', 'midiChan':  0, 'spec': 'midiCC'),
		// 	elements: [74, 71, 10, 7, 73, 72, 91, 93].collect { |ccnum, i|
		// 		('midiNum': ccnum, style: (row: i div: 4 + 2, column: i % 4 ))
		// 	}
		// ),


		(key: \bt,
			shared: ('elementType': 'pad', groupType: \noteOnOffBut, spec: 'midiBut' ),
			elements: [
				['EQ1', 42, (style: (row: 2, column: 0))],
				['EQ2', 50, (style: (row: 2, column: 1))],
				['EQ3', 44, (style: (row: 2, column: 2))],
				['EQ4', 116, (style: (row: 2, column: 3))],

				['F1', 	54, (style: (row: 3, column: 0))],
				['F2', 	55, (style: (row: 3, column: 1))],
				['F3', 	56, (style: (row: 3, column: 2))],
				['F4', 	57, (style: (row: 3, column: 3))],

				['shift', 70, (style: (row: 4, column: 1.5))],

				['chanL', 48, (style: (row: 5, column: 0))],
				['chanR', 49, (style: (row: 5, column: 1))],
				['R', 81, (style: (row: 5, column: 2))],
				['W', 78, (style: (row: 5, column: 3))]
			].collect { |list, i|
				(key: list[0], midiNum: list[1], shared: list[2])
			}
		),
	]
)
);
