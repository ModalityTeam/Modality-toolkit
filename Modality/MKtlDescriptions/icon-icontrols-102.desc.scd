/*

This is for the older version of the iCon iControls,
which registers as "iCON iControl V1.02".

It registers on two midi in ports and 1 out,
and the joystick registers as an HID device (a mouse).
midi port 2 seems to do nothing, so there is no second desc file for it.

While the icontrols has four layers,
sliders only work fully in layer 1,
so this desc only addresses  layer 1.

In the iControls app, select mapping "user defined",
then the controller number below will match.
They are different from the ones given in  "icon-icontrols" (V2.00).


// tests:
MKtlDesc.loadDescs;
m.free; m = MKtl(\ic, "*icontrols-102", multiIndex: 0);
k.trace; k.gui;

m.elAt.action = { |el| el.name.postln };
m.elementsDict.size;
m.postElements;
*/

(
deviceName: "iCON iControl V1.02",
protocol: \midi,
deviceType: \faderbox,
elementTypes: [\fader, \knob, \button],
status: (
	linux: "unknown",
	osx: "tested and working, adc, 2016-05-05.",
	win: "unknown"),

idInfo: (deviceName: "iCON iControl V1.02", srcPortIndex: 0, destPortIndex: 0),

deviceInfo: (
	vendorURI: "http://icon-global.com/product/icontrols/",
	manualURI: "http://support.icon-global.com/hc/en-us/articles/216201337-iControls",
	// description: "",
	// features: [],
	notes: "This is the main desc for MIDI port 1 of this device.\n"
	"It has a second midi port, which needs a desc file,\n"
	"and it also has an HID interface (..-hid).\n"
	"Layer buttons have no effect; the first MIDI port gives the data.",
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
			elements: (0..8).collect { |i, n|
				( midiChan: i, \style: (row: 0, column: 4+(n*2)) )
			}
		),
		(
			key: \sl,
			shared: (midiMsgType: \cc, elementType: \slider, midiNum:  13, spec: \midiCC),
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