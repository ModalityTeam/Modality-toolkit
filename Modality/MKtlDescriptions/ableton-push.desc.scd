/*
MKtlDesc.loadDescs("*push"); m.free; m = MKtl(\push, "*push").trace; m.gui;
*/
(
deviceName: "Ableton Push",
protocol: \midi,
deviceType: \push,
elementTypes: [\pad, \button, \encoder, \display, \bend],
status: (
	linux: "unknown",
	osx: "tested and working, 15.3.2016 by LFSaw.de. GUI layout is missing.",
	win: "unknown"),

idInfo: "Ableton Push",

deviceInfo: (
	vendorURI: "https://www.ableton.com/en/push/",
	manualURI: "https://www.ableton.com/en/manual/using-push/",
	description: "Official Ableton Live controller (version 1).",
	features: [
		"64 velocity and pressure-sensitive pads",
		"RGB backlighting",
		"11 touch-sensitive encoders",
		"4-line LCD alphanumeric display",
		"17 cm touch strip for pitch bend/scrolling",
		"24 LEDs for navigation",
	],
	notes:
	"Currently only ```User-mode``` supported.\n"
	"Usage:\n\n"
	"```\n"
	"m = MKtl('push', \"ableton*\", multiIndex: 1);\n"
	"```\n\n"
	"Helper class: ```MPush```",
	longName: "Ableton Push",
),

// display still missing because SysEx and different MIDI port...
elementsDesc: (
	shared: (midiChan: 0),
	elements: [
		//------ encoderTopRow
		(
			key: \kn,
			elements: [
				(
					key: \touch,
					shared: (
						elementType: 'pad', groupType: \noteOnOffBut,
						spec: \midiVel
					),
					elements: ( 0.. 8 ).collect { |num, i|
						(
							key: (num+1).asSymbol, midiNum: num,
							shared: (style: (row: -0.5, column: i + 2, height: 0.7))
						)
					}
				),
				(
					key: \turn,
					shared: (midiMsgType: \cc, elementType: \encoder, spec: \midiCC),
					elements: (71..79).collect { |num, i|
						(midiNum: num, style: (row: 0, column: 2 + i))
					}
				)
			]
		),
		//------ pads -------------
		(
			key: \pad,
			shared: (elementType: \pad, groupType: \noteOnOffTouch),
			elements: (36..99).clump(8).reverse.collect { |rownums, i|
				(
					elements: rownums.collect { |num, j|
						(
							shared: (midiNum: num, style: (row: i + 4, column: j + 2))
						)
					}
				)
			}
		),
		//------ ribbon -----------
		(
			key: \ribbon,
			elements: [
				(
					key: \touch, midiNum: 12,
					groupType: \noteOnOffBut,
					shared: (
						groupType: \noteOnOffBut,
						elementType: 'pad',
						midiChan: 0,
						spec: 'midiBut',
						style: (row: 4, column: 1)
					)
				),
				(
					key: \bend,
					midiMsgType: 'bend',
					elementType: 'ribbon',
					spec: 'midiBend',
					style: (row: 5, column: 1, height: 7)
				)
			]
		),
		//------ side encoders (not in a group because very different in experience)
		(
			key: \knLeft,
			elements: [
				(
					key: \touch, midiNum: 10,
					groupType: \noteOnOffBut,
					shared: (
						elementType: \pad, groupType: \noteOnOffBut,
						spec: \midiVel,
						style: (row: 3, column: 0, height: 0.4)
					),
				),
				(
					key: \turn,
					midiMsgType: \cc,
					elementType: \encoder,
					midiNum: 14,
					spec: \midiBut,
					style: (row: 3.4, column: 0, height: 0.8)
				)
			]
		),
		(
			key: \knRight,
			elements: [
				(
					key: \touch, midiNum: 9,
					groupType: \noteOnOffBut,
					shared: (
						elementType: \pad, groupType: \noteOnOffBut,
						spec: \midiVel,
						style: (row: 3, column: 1, height: 0.4)
					),
				),
				(
					key: \turn,
					midiMsgType: \cc,
					elementType: \encoder,
					midiNum: 15,
					spec: \midiBut,
					style: (row: 3.4, column: 1, height: 0.8)
				)
			]
		),
		//------ color button rows
		(
			key: \bt,
			shared: (midiMsgType: 'cc', elementType: 'pad',
				spec: 'midiCC', ioType: \inout),
			elements: [(20..27), (102..109)].collect { |row, i|
				(
					shared: (groupType: \noteOnOffBut),
					elements: row.collect { |num, j|
						(midiNum: num,
							shared: (style: (row: i * 0.5 + 3, column: j + 2, height: 0.6)))
				})
			}
		),
		//------ note length buttons

		(
			key: \btLen,
			shared: (midiMsgType: 'cc', elementType: 'button',
				spec: 'midiCC', ioType: \inout),
			elements: [
				(key: '132t', midiNum: 43, style: (row: 4, column: 10)),
				(key: '132',  midiNum: 42, style: (row: 5, column: 10)),
				(key: '116t', midiNum: 41, style: (row: 6, column: 10)),
				(key: '116',  midiNum: 40, style: (row: 7, column: 10)),
				(key: '18t',  midiNum: 39, style: (row: 8, column: 10)),
				(key: '18',   midiNum: 38, style: (row: 9, column: 10)),
				(key: '14t',  midiNum: 37, style: (row: 10, column: 10)),
				(key: '14',   midiNum: 36, style: (row: 11,column: 10))
			]
		),
		// // ------ ctl buttons
		(
			key: \btCtl,
			shared: (midiMsgType: 'cc', elementType: 'button',
				spec: 'midiCC', ioType: \inout),
			elements: [
				(key: \tapTempo, midiNum: 3, style: (row: 1, column: 0)),
				(key: \metronome, midiNum: 9, style: (row: 2, column: 0, height: 0.7)),

				(key: \undo, 	midiNum: 119, style: (row: 4, column: 0, height: 0.8)),
				(key: \delete, 	midiNum: 118, style: (row: 4.7, column: 0, height: 0.8)),
				(key: \double, 	midiNum: 117, style: (row: 5.4, column: 0, height: 0.8)),
				(key: \quantize, midiNum: 116, style: (row: 6.1, column: 0, height: 0.8)),

				(key: \fixedLength, midiNum: 90, style: (row: 7, column: 0, height: 0.8)),
				(key: \automation,  midiNum: 89, style: (row: 7.7, column: 0, height: 0.8)),
				(key: \duplicate,   midiNum: 88, style: (row: 8.4, column: 0, height: 0.8)),
				(key: \new, 		midiNum: 87, style: (row: 9, column: 0)),
				(key: \record, 		midiNum: 86, style: (row: 10, column: 0)),
				(key: \play, 		midiNum: 85, style: (row: 11, column: 0)),

				(key: \master, 		midiNum: 28, style: (row: 3.0, column: 10, height: 0.6)),
				(key: \stop, 		midiNum: 29, style: (row: 3.5, column: 10, height: 0.6)),


				(key: \volume, 	midiNum: 114, style: (row: 1.0, column: 11, height: 0.8)),
				(key: \track, 	midiNum: 112, style: (row: 1.6, column: 11, height: 0.8)),
				(key: \device, 	midiNum: 110, style: (row: 2.2, column: 11, height: 0.8)),

				(key: \in, 		midiNum:  62, style: (row: 3.0, column: 11, height: 0.8)),
				(key: \mute, 	midiNum:  60, style: (row: 3.6, column: 11, height: 0.8)),
				(key: \scales, 	midiNum:  58, style: (row: 4.2, column: 11, height: 0.8)),
				(key: \repeat, 	midiNum:  56, style: (row: 4.8, column: 11, height: 0.8)),
				(key: \octaveDown,midiNum:54, style: (row: 5.4, column: 11, height: 0.8)),

				(key: \addEffect,midiNum:52, style:(row: 7.0, column: 11, height: 0.8)),
				(key: \note, 	midiNum: 50, style: (row: 7.6, column: 11, height: 0.8)),
				(key: \select, 	midiNum: 48, style: (row: 8.2, column: 11, height: 0.8)),

				(key: \panSend, midiNum: 115, style: (row: 1.0, column: 12, height: 0.8)),
				(key: \clip, 	midiNum: 113, style: (row: 1.6, column: 12, height: 0.8)),
				(key: \browse, 	midiNum: 111, style: (row: 2.2, column: 12, height: 0.8)),

				(key: \out, 	midiNum: 63, style: (row: 3.0, column: 12, height: 0.8)),
				(key: \solo, 	midiNum: 61, style: (row: 3.6, column: 12, height: 0.8)),
				(key: \user, 	midiNum: 59, style: (row: 4.2, column: 12, height: 0.8)),
				(key: \accent, 	midiNum: 57, style: (row: 4.8, column: 12, height: 0.8)),
				(key: \octaveUp,midiNum: 55, style: (row: 5.4, column: 12, height: 0.8)),

				(key: \addTrack,midiNum: 53, style: (row: 7.0, column: 12, height: 0.8)),
				(key: \session, midiNum: 51, style: (row: 7.6, column: 12, height: 0.8)),
				(key: \shift, 	midiNum: 49, style: (row: 8.2, column: 12, height: 0.8)),

				(key: \left, 	midiNum: 44, style: (row: 9.8, column: 11, height: 0.8)),
				(key: \right, 	midiNum: 45, style: (row: 9.8, column: 12, height: 0.8)),
				(key: \up, 		midiNum: 46, style: (row: 9.2, column: 11.5, height: 0.8)),
				(key: \down, 	midiNum: 47, style: (row: 10.4, column: 11.5, height: 0.8))
			]
		),
		(
			key: \pedal,
			shared: (midiMsgType: 'cc', elementType: 'button',
				spec: 'midiCC', ioType: \in
			),
			elements: [
				(key: '1', midiNum: 64, style: (row: 11, column: 11)),
				(key: '2', midiNum: 69, style: (row: 11, column: 12))
			]

		)
	]
)
)