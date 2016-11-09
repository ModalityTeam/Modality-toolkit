/*

This desc file is the one based on nescivis desc for icontrol 2.00.
should be replaced by icontrols-200 when that is known to be correct.
---

The iCon iControls registers on two midi ports (in and out),
and the joystick on it registers as an HID device.

This desc file is for port 1, assuming that the main body
of midi messages will come thru port 1. For port 2, a second
desc file might be necessary, and can be made by copying this
file, changing the entry for idInfo to:

idInfo: (deviceName: "iCON iControls V2.00", srcPortIndex: 0, destPortIndex: 0),

removing the elements that do not communicate via port 2,
and adding any others that do.


// tests:
thisProcess.nowExecutingPath.basename.split($.).first.postcs;
d = MKtlDesc.loadDescs("*icontrols").first;

MKtlDesc.loadDescs("*icontrols");
m.free; m = MKtl(\ic, "*icontrols"); m.trace.gui;

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