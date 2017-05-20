/*

This is for the older version of the iCon iControls,
which registers as "iCON iControl V1.01".

// tests:
MKtlDesc.loadDescs;
m.free; m = MKtl(\ic, "*icontrols-101"); m.trace.gui;

m.elAt.action = { |el| el.name.postln };
m.elementsDict.size;
m.postElements;
*/

(
deviceName: "iCON iControl V1.01",

idInfo: (deviceName: "iCON iControl V1.01", srcPortIndex: 0, destPortIndex: 0),

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
	description: "For older version of the iCon iControls registering as \"iCON iControl V1.01\".",
	// features: [],
	notes: ""
	// hasScribble: false
),



elementsDesc: (
	elements: [
		(
			key: \tr,
			shared: (elementType: \button, midiChan: 0, spec: \midiBut),
			elements: [
				MKtlDesc.notePair( \rew,  21, shared: ( \style: (row: 0, column: 0, showLabel: true) ) ),
				MKtlDesc.notePair( \play, 24, shared: ( \style: (row: 0, column: 1, showLabel: true) ) ),
				MKtlDesc.notePair( \fwd,  22, shared: ( \style: (row: 0, column: 2, showLabel: true) ) ),
				MKtlDesc.notePair( \cycle,20, shared: ( \style: (row: 1, column: 0, showLabel: true) ) ),
				MKtlDesc.notePair( \stop, 23, shared: ( \style: (row: 1, column: 1, showLabel: true) ) ),
				MKtlDesc.notePair( \rec,  25, shared: ( \style: (row: 1, column: 2, showLabel: true) ) )
			]
		),
		(
			key: \kn,
			shared: (midiMsgType: \cc, elementType: \knob, midiNum: 12, spec: \midiCC),
			elements:
			(0..8).collect { |i, n|
				( midiChan: i, \style: (row: 0, column: 4+(n*2)) )
			}
		),

		(
			key: \sl,
			shared: (midiMsgType: \cc, elementType: \slider, midiNum:  21, spec: \midiCC),
			elements: (0..8).collect { |i, n|
				( midiChan: i, \style: (row: 1, column: 4+(i*2)))
			}
		),
		(
			key: \bt,
			shared: (elementType: \button, midiChan: 0, spec: \midiBut),
			elements: #[ 26, 27 ].collect { |midiNum, row|
				(
					shared: (midiNum: midiNum),
					elements: (0..8).collect { |chan, col|
						MKtlDesc.notePair(col+1, midiNum,
							shared: ( midiChan: chan,
								\style: (row: row+2, column: 3 + (col*2), showLabel: false))
						);
					}
				)
			}
		)
	]
)
);