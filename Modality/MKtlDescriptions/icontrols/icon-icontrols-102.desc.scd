/*

This is for the older version of the iCon iControls,
which registers as "iCON iControl V1.02".

// tests:
MKtlDesc.loadDescs;
m.free; m = MKtl(\ic, "*icontrols-102"); m.trace.gui;

m.elAt.action = { |el| el.name.postln };
m.elementsDict.size;
m.postElements;
*/

(
deviceName: "iCON iControl V1.02",

idInfo: (deviceName: "iCON iControl V1.02", srcPortIndex: 0, destPortIndex: 0),

status: (
	linux: "unknown",
	osx: "tested and working, adc, 2016-05-05.",
	win: "unknown"),

protocol: \midi,
deviceType: \faderbox,
elementTypes: [\fader, \knob, \button],

deviceInfo: (
	vendorURI: "http://icon-global.com/product/icontrols/",
	manualURI: "http://support.icon-global.com/hc/en-us/articles/216201337-iControls",
	// description: "",
	// features: [],
	notes: ""
	// hasScribble: false
),



elementsDesc: (
	elements: [
		(
			key: \bt,
			shared: (elementType: \pad, midiChan: 0, spec: \midiBut),
			elements: #[
				[ 16, 17, 18, 19, 20, 21, 22, 23, 48 ],
				[  8,  9, 10, 11, 12, 13, 14, 15, 49 ]
			].collect { |xs, row|
				(
					elements: xs.collect { |note, col|
						(
							key: col, midiNum: note, groupType: \noteOnOffBut,
							shared: (
								groupType: \noteOnOffBut,
								\style: (row: row+2, column: 3 + (col*2))
							)
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
			shared: (elementType: \pad, midiChan: 0, groupType: \noteOnOffBut, spec: \midiBut),
			elements: [
				( key: \rew, 	midiNum: 91, shared: ( \style: (row: 0, column: 0) ) ),
				( key: \play, 	midiNum: 94, shared: ( \style: (row: 0, column: 1) ) ),
				( key: \fwd, 	midiNum: 92, shared: ( \style: (row: 0, column: 2) ) ),
				( key: \cycle, 	midiNum: 86, shared: ( \style: (row: 1, column: 0) ) ),
				( key: \stop, 	midiNum: 93, shared: ( \style: (row: 1, column: 1) ) ),
				( key: \rec, 	midiNum: 95, shared: ( \style: (row: 1, column: 2) ) )
			]
		)
	]
)
);