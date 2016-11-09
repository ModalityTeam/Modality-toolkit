/*

This desc file is copied from the one for   "iCON iControl V1.02",
assuming the newer icontrols registering as "iCON iControls V2.00"
will have the same midi numbering scheme.

General info:
It registers on two midi in ports and 1 out,
and the joystick registers as an HID device (a mouse).
midi port 2 seems to do nothing, so there is no second desc file for it.

ISSUES:
While the icontrols has four layers, the sliders only work fully in layer 1;
this may be generally so, or an issue with the device I had for testing.
For now, this this desc only addresses  layer 1.

To make sure your icontrols uses the default numbers,
get the iControls app, select mapping "user defined",
then the controller number below will match.
They are different from the ones given in
the linux-based desc file "icon-icontrols" (V2.00).


// tests:
MKtlDesc.loadDescs;
m.free; m = MKtl(\ic, "*icontrols-200"); m.trace; m.gui;

m.elAt.action = { |el| el.name.postln };
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
	osx: "tested desc, looks ok.",
	win: "unknown"),

idInfo: (deviceName: "iCON iControls V2.00", srcPortIndex: 0, destPortIndex: 0),

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