/*
MKtlDesc.loadDescs("*wing");
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
	osx: "partly working, sends more data than in manual",
	win: "unknown"),

idInfo: "Livid Guitar Wing",


deviceInfo: (
	vendorURI: "http://lividinstruments.com/products/guitar-wing/",
	manualURI: "http://lividinstruments.com/support/",
	description: "controller for guitar",
	features: [],
	notes: "_none_",
	hasScribble: true
),

'elementsDesc': (
		//	noteOn 127 for start, cc for val, noteOff 0
	elements: [
		(
			key: \fader,
			shared: (type: \touchFader, spec: \midiCC, midiChan: 0),
			elements: [
				[\l, 1],
				[\r, 2],
				[\bot, 3]
			].collect { |pair, i|
					var name, num; #name, num = pair;
				(
					key: name,
					shared: (midiNum: num),
					elements: [
						MKtlDesc.notePair(\touch, num),
						(key: \pos,   midiMsgType: \control)
					]
				)
			}
		),
		// noteOn 64 noteOff 0, toggle
		MKtlDesc.notePair(\tipPad, 4)
			.putAll(
				( type: \pad, mode: \toggle, \spec: \midiCC )
		),

		// noteOnOff, momentary
		(
			key: \pad,
			shared: (elementType: \touchButton, spec: \midiCC, midiChan: 0),
			elements: [
				MKtlDesc.notePair(\idx, 36),
				MKtlDesc.notePair(\mid, 37),
				MKtlDesc.notePair(\rng, 38),
				MKtlDesc.notePair(\pnk, 39),
			]
		),
		(
			key: \sw,
			shared: (type: \touchButton, spec: \midiCC, midiChan: 0),
			elements: [
				MKtlDesc.notePair( \triDn,  40),
				MKtlDesc.notePair( \triUp,  41),

				MKtlDesc.notePair( \idx,  42),
				MKtlDesc.notePair( \mid,  43),
				MKtlDesc.notePair( \rng,  44),
				MKtlDesc.notePair( \pnk,  45),
			]
		),
		(
			key: \cutsw,
			shared: (type: \switch, spec: \midiCC, midiChan: 0),
			elements: [
				MKtlDesc.notePair( \1, 46),
				MKtlDesc.notePair( \2, 47),
				MKtlDesc.notePair( \3, 48),
				MKtlDesc.notePair( \4, 49)
			]
		),
		(
			key: \accel,
			shared: (type: \accelAxis, spec: \midiCC, midiChan: 0, midiMsgType: \control),
			elements: [
				(key: \x, midiNum: 5),
				(key: \y, midiNum: 6),
				(key: \z, midiNum: 7)
			]
		)
	]
)
)
);