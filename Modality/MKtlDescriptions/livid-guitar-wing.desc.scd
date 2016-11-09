/*

// test this desc:
thisProcess.nowExecutingPath.basename.split($.).first.postcs;

d = MKtlDesc.loadDescs("*wing").first;
m.free; m = MKtl(\gw, "*wing").trace;
m.gui;
m.elementsDict.size;
m.postElements;
*/
//
(
(
deviceName: "Livid Guitar Wing",
protocol: 'midi',
deviceType: \multiController,
elementTypes: [\button, \touchFader, \pad],
status: (
	linux: "unknown",
	osx: "tested and working. 2016-03-16, adc",
	win: "unknown"),

idInfo: "Livid Guitar Wing",


deviceInfo: (
	vendorURI: "http://lividinstruments.com/products/guitar-wing/",
	manualURI: "http://lividinstruments.com/support/",
	description: "controller for guitar",
	features: [],
	notes: "_none_",
	longName: "Livid Guitar Wing"
),

specs: ( midiBut64: [0, 64, \lin, 64] ),

'elementsDesc': (
	shared: (midiChan: 0),
	//	noteOn 127 for start, cc for val, noteOff 0
	elements: [
		(
			key: \fader,
			shared: (elementType: \pad, groupType: \noteOnOffButCtl, spec: \midiCC),
			elements: [
				(
					key: \bot,
					shared: (midiNum: 3, style: (height: 4, row: 0, column: 2))
				),
				(
					key: \l,
					shared: (midiNum: 1, style: (width: 2, row: 5.2, column: 4)),
				),
				(
					key: \r,
					shared: (midiNum: 2, style: (width: 2, row: 5.2, column: 6)),
				),
			]
		),

		(
			key: \tipPad, \groupType: \noteOnOff, midiNum: 4,
			shared: (
				elementType: \pad, \groupType: \noteOnOff,
				mode: \toggle, \spec: \midiBut64,
				style: (row: 0, column: 0)
			)
		),

		// noteOn/Off, momentary + cc
		(
			key: \pad,
			shared: (elementType: \pad, groupType: \noteOnOffCtl, spec: \midiCC),
			elements: [
				(
					key: \idx, midiNum: 36, shared: (style: (row: 3.5 + 1, column: 3))
				),
				(
					key: \mid, midiNum: 37, shared: (style: (row: 3.0 + 1, column: 4.3))
				),
				(
					key: \rng, midiNum: 38, shared: (style: (row: 3.1 + 1, column: 5.6))
				),
				(
					key: \pnk, midiNum: 39, shared: (style: (row: 3.2 + 1, column: 7))
				),
			]
		),
		(
			key: \sw,
			shared: (elementType: \pad, groupType: \noteOnOffBut, spec: \midiBut64),
			elements: [
				(key:  \triDn,  midiNum: 40, shared: (style: (row: 0.5, column: 3))),
				(key:  \triUp,  midiNum: 41, shared: (style: (row: 1.5, column: 3))),

				(key:  \idx,  midiNum: 42, shared: (style: (row: 2, column: 4))),
				(key:  \mid,  midiNum: 43, shared: (style: (row: 2, column: 5))),
				(key:  \rng,  midiNum: 44, shared: (style: (row: 2, column: 6))),
				(key:  \pnk,  midiNum: 45, shared: (style: (row: 2, column: 7))),
			]
		),
		(
			key: \cutsw,
			shared: (elementType: \pad, groupType: \noteOnOffBut, spec: \midiBut64),
			elements: [
				(key:  \1, midiNum: 46, shared: (style: (row: 1, column: 0))),
				(key:  \2, midiNum: 47, shared: (style: (row: 2, column: 0.4))),
				(key:  \3, midiNum: 48, shared: (style: (row: 3, column: 0.7))),
				(key:  \4, midiNum: 49, shared: (style: (row: 4, column: 0.7)))
			]
		),
		(
			key: \accel,
			shared: (elementType: \accelAxis, spec: \midiCC, midiMsgType: \control),
			elements: [
				(key: \x, midiNum: 5, style: (type: \slider, height: 2)),
				(key: \y, midiNum: 6, style: (type: \slider, height: 2)),
				(key: \z, midiNum: 7, style: (type: \slider, height: 2))
			]
		)
	]
)
)
);