/*
// ToDo:
* organisation of elements maybe not ideal yet.

// test this desc:
thisProcess.nowExecutingPath.basename.split($.).first.postcs;

d = MKtlDesc.loadDescs("*wing").first;
m.free; m = MKtl(\gw, "*wing"); m.gui;

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

specs: (midiBut64: [0, 64, \lin, 64]),

'elementsDesc': (
	shared: (midiChan: 0),
		//	noteOn 127 for start, cc for val, noteOff 0
	elements: [
		(
			key: \fader,
			shared: (elementType: \slider, spec: \midiCC),
			elements: [
				(key: \bot,
					shared: (midiNum: 3),
					elements: [
						(key: \pos, midiMsgType: \control, elementType: \slider,
							style: (height: 4, row: 0, column: 2)
						),
						MKtlDesc.notePair(\touch, 3,
							(style: (row: 3.9, column: 2), elementType: \pad)
						)
					]
				),
				(key: \l,
					shared: (midiNum: 1),
					elements: [
						(key: \pos, midiMsgType: \control, elementType: \slider,
							style: (width: 2, height: 0.9, row: 5.2, column: 4)
						),
						MKtlDesc.notePair(\touch, 1,
							(style: (row: 6, column: 4.5), elementType: \pad)
						)
					]
				),
				(key: \r,
					shared: (midiNum: 2),
					elements: [
						(key: \pos, midiMsgType: \control, elementType: \slider,
							style: (width: 2, height: 0.9, row: 5.2, column: 6)
						),
						MKtlDesc.notePair(\touch, 2,
							(style: (row: 6, column: 6.5), elementType: \pad)
						)
					]
				)
			]
		),
		// noteOn 64 noteOff 0, toggle
		MKtlDesc.notePair(\tipPad, 4,
			( elementType: \pad, mode: \toggle, \spec: \midiBut64,
				style: (row: 0, column: 0)
			)
		),

		// noteOn/Off, momentary + cc
		(
			key: \pad,
			shared: (elementType: \pad, spec: \midiCC),
			elements: [
				(
					elements: [
						(key: \press, elementType: \slider, midiMsgType: \control, midiNum: 36,
							style: (row: 3.5, column: 3, height: 1)
						),
						MKtlDesc.notePair(\idx, 36, (style: (row: 3.5 + 1, column: 3))),
					]
				),
				(
					elements: [
						(key: \press, elementType: \slider, midiMsgType: \control, midiNum: 37,
							style: (row: 3.0, column: 4.3, height: 1)
						),
						MKtlDesc.notePair(\mid, 37, (style: (row: 3.0 + 1, column: 4.3))),
					]
				),
				(
					elements: [
						(key: \press, elementType: \slider, midiMsgType: \control, midiNum: 38,
							style: (row: 3.1, column: 5.6, height: 1)
						),
						MKtlDesc.notePair(\rng, 38, (style: (row: 3.1 + 1, column: 5.6))),
					]
				),
				(
					elements: [
						(key: \press, elementType: \slider, midiMsgType: \control, midiNum: 39,
							style: (row: 3.2, column: 7, height: 1)
						),
						MKtlDesc.notePair(\pnk, 39, (style: (row: 3.2 + 1, column: 7))),
					]
				),
			]
		),
		(
			key: \sw,
			shared: (elementType: \pad, spec: \midiBut64),
			elements: [
				MKtlDesc.notePair( \triDn,  40, (style: (row: 0.5, column: 3))),
				MKtlDesc.notePair( \triUp,  41, (style: (row: 1.5, column: 3))),

				MKtlDesc.notePair( \idx,  42, (style: (row: 2, column: 4))),
				MKtlDesc.notePair( \mid,  43, (style: (row: 2, column: 5))),
				MKtlDesc.notePair( \rng,  44, (style: (row: 2, column: 6))),
				MKtlDesc.notePair( \pnk,  45, (style: (row: 2, column: 7))),
			]
		),
		(
			key: \cutsw,
			shared: (elementType: \pad, spec: \midiBut64),
			elements: [
				MKtlDesc.notePair( \1, 46, (style: (row: 1, column: 0))),
				MKtlDesc.notePair( \2, 47, (style: (row: 2, column: 0.4))),
				MKtlDesc.notePair( \3, 48, (style: (row: 3, column: 0.7))),
				MKtlDesc.notePair( \4, 49, (style: (row: 4, column: 0.7)))
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