//	// Elektron Digitakt
// premliminary support for midi sequencer
// MIDI A sends channel  8 (called  9 on DT)
// MIDI B sends channel  9 (called 10 on DT)
// MIDI C sends channel 10 (called 11 on DT)
// MIDI D sends channel 11 (called 12 on DT)
// MIDI E sends channel 12 (called 13 on DT)
// MIDI F sends channel 13 (called 14 on DT)
// MIDI G sends channel 14 (called 15 on DT)
// MIDI H sends channel 15 (called 16 on DT)

/*

MKtl.find;

MKtl('dt', 'midi_2_elektron_digitakt');
MKtlDesc.writeCaches
MKtlDesc.descFolders

explore
MKtl('dt', "elektron-digitakt");
MKtl('dt').trace
MIDIFunc.trace

MKtl('dt').elAt(\kn)


MKtlDesc.loadCaches
MKtlDesc.writeCaches

"/Users/tboverma/Library/Application Support/SuperCollider/MKtlDescriptions/_allDescs.cache.scd"
*/


(
deviceName: "Elektron Digitakt",
protocol: 'midi',
deviceType: 'sequencer',
elementTypes: [\pianokey, \knob, \button, \sequencer],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "Elektron Digitakt",

hardwarePages: [9, 10, 11, 12, 13, 14, 15, 16],

deviceInfo: (
	vendorURI: 'https://www.elektron.se/',
	manualURI: 'https://www.elektron.se/support/?connection=digitakt#resources',
	description: "Compact drum machine containing all the necessary tools to make people move to the beat.",
	// features: [],
	notes: "Premliminary support for midi sequencer part and mute buttons.",
	// hasScribble: false
),
elementsDesc: (
	elements: [(8..15), ['mida', 'midb', 'midc', 'midd', 'mide', 'midf', 'midg', 'midh']].flop.collect{|desc, i|
		(
			key: desc[1],
			shared: (midiChan: desc[0], page: desc[0]+1),
			elements: [
				(
					key: \kn,
					shared: (elementType: \knob,
						\spec: \midiCC, \ioType: \in),
					elements: [(70..77), [\A, \B, \C, \D, \E, \F, \G, \H]].flop.collect { |desc, i|
						var num, label;
						#num, label = desc;
						(midiMsgType: \cc, midiNum: num, labels: [label])
					}
				),
				(
					key: \note,
					shared: (\elementType: \knob, groupType: \noteOnOff,
						\spec: \midiVel, \ioType: \inout
					),
					elements: 128.collect{|i|
						(key: i.asSymbol, midiNum: i, shared: (style: (row: 3, column: 0)))
					}
				),
				(key: \pb, ioType: \in, elementType: \knob, spec: \midiBend, midiMsgType: \bend),
				(key: \at, ioType: \in, elementType: \knob, spec: \midiCC, midiMsgType: \touch),
				(key: \mw, ioType: \in, elementType: \knob, spec: \midiCC, midiMsgType: \cc, midiNum: 1),
				(key: \bc, ioType: \in, elementType: \knob, spec: \midiCC, midiMsgType: \cc, midiNum: 2),
				// undocumented, cc 120 to 0 is equal to "all sound off" (https://www.midi.org/specifications/item/table-1-summary-of-midi-message)
				(key: \soundOff, ioType: \in, elementType: \knob, spec: \midiCC, midiMsgType: \cc, midiNum: 120),			]
		)
	}
)
);


// 		// ------ cc -------------
// 		( key: 'cc_0_094', 'midiNum':  94, 'midiChan': 0, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_10_094', 'midiNum':  94, 'midiChan': 10, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_11_094', 'midiNum':  94, 'midiChan': 11, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_12_094', 'midiNum':  94, 'midiChan': 12, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_13_094', 'midiNum':  94, 'midiChan': 13, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_14_094', 'midiNum':  94, 'midiChan': 14, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_15_094', 'midiNum':  94, 'midiChan': 15, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_1_094', 'midiNum':  94, 'midiChan': 1, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_2_094', 'midiNum':  94, 'midiChan': 2, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_3_094', 'midiNum':  94, 'midiChan': 3, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_4_094', 'midiNum':  94, 'midiChan': 4, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_5_094', 'midiNum':  94, 'midiChan': 5, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_6_094', 'midiNum':  94, 'midiChan': 6, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_7_094', 'midiNum':  94, 'midiChan': 7, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_8_001', 'midiNum':  1, 'midiChan': 8, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_8_002', 'midiNum':  2, 'midiChan': 8, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_8_070', 'midiNum':  70, 'midiChan': 8, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_8_071', 'midiNum':  71, 'midiChan': 8, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_8_072', 'midiNum':  72, 'midiChan': 8, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_8_073', 'midiNum':  73, 'midiChan': 8, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_8_074', 'midiNum':  74, 'midiChan': 8, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_8_075', 'midiNum':  75, 'midiChan': 8, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_8_076', 'midiNum':  76, 'midiChan': 8, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_8_077', 'midiNum':  77, 'midiChan': 8, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_8_094', 'midiNum':  94, 'midiChan': 8, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_9_070', 'midiNum':  70, 'midiChan': 9, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_9_071', 'midiNum':  71, 'midiChan': 9, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_9_072', 'midiNum':  72, 'midiChan': 9, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_9_073', 'midiNum':  73, 'midiChan': 9, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_9_074', 'midiNum':  74, 'midiChan': 9, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_9_075', 'midiNum':  75, 'midiChan': 9, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_9_076', 'midiNum':  76, 'midiChan': 9, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_9_077', 'midiNum':  77, 'midiChan': 9, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
// 		( key: 'cc_9_094', 'midiNum':  94, 'midiChan': 9, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),

// 		// ------ noteOn -------------
// 		( key: 'nOn_10_060', 'midiNum':  60, 'midiChan': 10, 'midiMsgType': 'noteOn', 'elementType': 'pad', 'spec': 'midiVel'),
// 		( key: 'nOn_11_060', 'midiNum':  60, 'midiChan': 11, 'midiMsgType': 'noteOn', 'elementType': 'pad', 'spec': 'midiVel'),
// 		( key: 'nOn_12_060', 'midiNum':  60, 'midiChan': 12, 'midiMsgType': 'noteOn', 'elementType': 'pad', 'spec': 'midiVel'),
// 		( key: 'nOn_13_060', 'midiNum':  60, 'midiChan': 13, 'midiMsgType': 'noteOn', 'elementType': 'pad', 'spec': 'midiVel'),
// 		( key: 'nOn_14_060', 'midiNum':  60, 'midiChan': 14, 'midiMsgType': 'noteOn', 'elementType': 'pad', 'spec': 'midiVel'),
// 		( key: 'nOn_15_060', 'midiNum':  60, 'midiChan': 15, 'midiMsgType': 'noteOn', 'elementType': 'pad', 'spec': 'midiVel'),
// 		( key: 'nOn_8_000', 'midiNum':  0, 'midiChan': 8, 'midiMsgType': 'noteOn', 'elementType': 'pad', 'spec': 'midiVel'),
// 		( key: 'nOn_9_060', 'midiNum':  60, 'midiChan': 9, 'midiMsgType': 'noteOn', 'elementType': 'pad', 'spec': 'midiVel'),

// 		// ------ noteOff -------------
// 		( key: 'nOff_10_060', 'midiNum':  60, 'midiChan': 10, 'midiMsgType': 'noteOff', 'elementType': 'pad', 'spec': 'midiVel'),
// 		( key: 'nOff_11_060', 'midiNum':  60, 'midiChan': 11, 'midiMsgType': 'noteOff', 'elementType': 'pad', 'spec': 'midiVel'),
// 		( key: 'nOff_12_060', 'midiNum':  60, 'midiChan': 12, 'midiMsgType': 'noteOff', 'elementType': 'pad', 'spec': 'midiVel'),
// 		( key: 'nOff_13_060', 'midiNum':  60, 'midiChan': 13, 'midiMsgType': 'noteOff', 'elementType': 'pad', 'spec': 'midiVel'),
// 		( key: 'nOff_14_060', 'midiNum':  60, 'midiChan': 14, 'midiMsgType': 'noteOff', 'elementType': 'pad', 'spec': 'midiVel'),
// 		( key: 'nOff_15_060', 'midiNum':  60, 'midiChan': 15, 'midiMsgType': 'noteOff', 'elementType': 'pad', 'spec': 'midiVel'),
// 		( key: 'nOff_8_000', 'midiNum':  0, 'midiChan': 8, 'midiMsgType': 'noteOff', 'elementType': 'pad', 'spec': 'midiVel'),
// 		( key: 'nOff_9_060', 'midiNum':  60, 'midiChan': 9, 'midiMsgType': 'noteOff', 'elementType': 'pad', 'spec': 'midiVel'),

// 		// ------- touch ------------
// 		( key: 'touch_8_000', 'midiChan': 8, 'midiMsgType': 'touch', 'elementType': 'touch', 'spec': 'midiCC'),

// 		// ------- touch ------------
// 		( key: 'bend_8_000', 'midiChan': 8, 'midiMsgType': 'bend', 'elementType': 'bender', 'spec': 'midiBend'),
// 	]
// )

// );

