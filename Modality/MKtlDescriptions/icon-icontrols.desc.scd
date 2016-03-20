/*
thisProcess.nowExecutingPath.basename.split($.).first.postcs;
d = MKtlDesc.loadDescs("*icontrols").first;
d.web;

m.free; m = MKtl(\ic, "*icontrols"); m.gui;
m.trace;
m.elementsDict.size;
m.postElements;
*/

(
deviceName: "iCON iControls V2.00",
protocol: \midi,
deviceType: \faderbox,
elementTypes: [\fader, \knob, \button],
status: (
	linux: "tested and working, 2016_03_20 by nescivi",
	osx: "unknown",
	win: "unknown"),

idInfo: "iCON iControls V2.00",

deviceInfo: (
	vendorURI: "http://www.icon-global.com/Controllers_MIDI+recording+controllers_iControls+.htm",
	manualURI: "http://www.icon-global.com/download%5Cuser%20manual%5CIC%20PD3V1.00-E.zip",
	// description: "",
	// features: [],
	notes: "This device also has an HID interface. Layer buttons have no effect; the first MIDI port gives the data",

	// hasScribble: false
),
elementsDesc: (
	elements: [
		(
			key: \bt,
			shared: (elementType: \button, midiChan: 0, spec: \midiBut),
			elements: #[
				[ 16, 17, 18, 19, 20, 21, 22, 23, 48 ],
				[  8,  9, 10, 11, 12, 13, 14, 15, 49 ]
			].collect { |xs, row|
				(
					elements: xs.collect { |note, col|
						MKtlDesc.notePair(col, note,
							shared: ( \style: (row: row+2, column: 3 + (col*2), showLabel: false))
						);
					}
				)
			}
		),
		(
			key: \sl,
			shared: (
				midiMsgType: \cc, elementType: \slider,
				midiNum:  13, spec: \midiCC),
			elements: (0..8).collect { |i, n| (
				midiChan: i,
				\style: (row: 1, column: 4+(i*2))
			) }
		),
		(
			key: \kn,
			shared: (midiMsgType: \cc, elementType: \knob,
				midiChan: 0, spec: \midiCC),
			elements: ((16..23)++[12]).collect { |i, n| (
				midiNum: i,
				\style: (row: 0, column: 4+(n*2))
			) }
		),
		(
			key: \tr,
			shared: (elementType: \button, midiChan: 0, spec: \midiBut),
			elements: [
				MKtlDesc.notePair( \rew, 	91, shared: ( \style: (row: 0, column: 0, showLabel: true) ) ),
				MKtlDesc.notePair( \play, 	94, shared: ( \style: (row: 0, column: 1, showLabel: true) ) ),
				MKtlDesc.notePair( \fwd, 	92, shared: ( \style: (row: 0, column: 2, showLabel: true) ) ),
				MKtlDesc.notePair( \cycle, 	86, shared: ( \style: (row: 1, column: 0, showLabel: true) ) ),
				MKtlDesc.notePair( \stop, 	93, shared: ( \style: (row: 1, column: 1, showLabel: true) ) ),
				MKtlDesc.notePair( \rec, 	95, shared: ( \style: (row: 1, column: 2, showLabel: true) ) )
			]
		)
	]
)
);