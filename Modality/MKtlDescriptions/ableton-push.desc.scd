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
	"Helper class: ```MPushHelper```",
	longName: "Ableton Push",
),

// display still missing because SysEx and different MIDI port...
elementsDesc: (
	shared: (midiChan: 0),
	elements: [
		//------ pads -------------
		(
			key: \pad,
			shared: (elementType: \pad),
			elements: (36..99).clump(8).reverse.collect { |rownums, i|
				(
					elements: rownums.collect { |num, j|
						(
							shared: (midiNum: num),
							elements: [
								(key: \on, 'midiMsgType': 'noteOn', 'spec': 'midiVel', ioType: \inout),
								(key: \off, 'midiMsgType': 'noteOff', 'spec': 'midiVel', ioType: \in),
								(key: \touch, 'midiMsgType': 'polyTouch', 'spec': 'midiCC', ioType: \in),
							]
						)
					}
				)
			}
		),
		//------ ribbon -----------
		(
			key: \ribbon,
			elements: [
				MKtlDesc.notePair(\touch, 12,
					shared: (
						elementType: 'button',
						midiChan: 0,
						spec: 'midiNote'
					)
				),
				(
					key: \bend,
					midiMsgType: 'bend',
					elementType: 'ribbon',
					spec: 'midiBend'
				)
			]
		),
		//------ encoderTopRow
		(
			key: \kn,
			elements: [
				(
					key: \touch,
					shared: (
						elementType: 'button',
						spec: \midiVel
					),
					elements: ( 0.. 8).collect { |num|
						MKtlDesc.notePair((num+1).asSymbol, num)
					}
				),
				(
					key: \turn,
					shared: (midiMsgType: \cc, elementType: \encoder,spec: \midiCC),
					elements: (71..79).collect { |num| (midiNum: num) }
				)
			]
		),
		//------ side encoders (not in a group because very different in experience)
		(
			key: \knLeft,
			elements: [
				MKtlDesc.notePair(\touch, 10,
					shared: (
						elementType: \button,
						spec: \midiVel

					),
				),
				(
					key: \turn,
					midiMsgType: \cc,
					elementType: \encoder,
					midiNum: 14,
					spec: \midiBut
				)
			]
		),
		(
			key: \knRight,
			elements: [
				MKtlDesc.notePair(\touch, 9,
					shared: (
						elementType: \button,
						spec: \midiVel

					),
				),
				(
					key: \turn,
					midiMsgType: \cc,
					elementType: \encoder,
					midiNum: 15,
					spec: \midiBut
				)
			]
		),
		//------ color button rows
		(
			key: \bt,
			shared: (midiMsgType: 'cc', elementType: 'button',
				spec: 'midiCC', ioType: \inout),
			elements: [(20..27), (102..109)].collect { |row, i|
				(
					elements: row.collect { |num, j|
						(midiNum: num)
				})
			}
		),
		//------ note length buttons

		(
			key: \btLen,
			shared: (midiMsgType: 'cc', elementType: 'button',
				spec: 'midiCC', ioType: \inout),
			elements: [
				(key: '132t', midiNum: 43),
				(key: '132',  midiNum: 42),
				(key: '116t', midiNum: 41),
				(key: '116',  midiNum: 40),
				(key: '18t',  midiNum: 39),
				(key: '18',   midiNum: 38),
				(key: '14t',  midiNum: 37),
				(key: '14',   midiNum: 36)
			]
		),
		//------ ctl buttons
		(
			key: \btCtl,
			shared: (midiMsgType: 'cc', elementType: 'button',
				spec: 'midiCC', ioType: \inout),
			elements: [
				(key: \tapTempo, midiNum: 3),
				(key: \metronome, midiNum: 9),
				(key: \undo, midiNum: 119),
				(key: \delete, midiNum: 118),
				(key: \double, midiNum: 117),
				(key: \quantize, midiNum: 116),
				(key: \fixedLength, midiNum: 90),
				(key: \automation, midiNum: 89),
				(key: \duplicate, midiNum: 88),
				(key: \new, midiNum: 87),
				(key: \record, midiNum: 86),
				(key: \play, midiNum: 85),
				(key: \stop, midiNum: 29),
				(key: \master, midiNum: 28),
				(key: \volume, midiNum: 114),
				(key: \track, midiNum: 112),

				(key: \device, midiNum: 110),
				(key: \in, midiNum: 62),
				(key: \mute, midiNum: 60),
				(key: \scales, midiNum: 58),
				(key: \repeat, midiNum: 56),
				(key: \octaveDown, midiNum: 54),
				(key: \addEffect, midiNum: 52),
				(key: \note, midiNum: 50),
				(key: \select, midiNum: 48),

				(key: \panSend, midiNum: 115),
				(key: \clip, midiNum: 113),
				(key: \browse, midiNum: 111),
				(key: \out, midiNum: 63),
				(key: \solo, midiNum: 61),
				(key: \user, midiNum: 59),
				(key: \accent, midiNum: 57),
				(key: \octaveUp, midiNum: 55),

				(key: \addTrack, midiNum: 53),
				(key: \session, midiNum: 51),
				(key: \shift, midiNum: 49),
				(key: \left, midiNum: 44),
				(key: \right, midiNum: 45),
				(key: \up, midiNum: 46),
				(key: \down, midiNum: 47)
			]
		),
		(
			key: \pedal,
			shared: (midiMsgType: 'cc', elementType: 'button',
				spec: 'midiCC', ioType: \in
			),
			elements: [
				(key: '1', midiNum: 64),
				(key: '2', midiNum: 69)
			]

		)
	]
)
)