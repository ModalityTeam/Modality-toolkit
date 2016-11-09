//	// KORG nanoKONTROL specs:
//	// only cc messages,
//	// 4 hardware scenes as pages

// TODO - but_4_2_1 overwrites kn_1_3 !
// * fix - likely disable but 2 1 in scene 4, and leave kn 1 3 on.
// * check whether there are any other clashes of cc numbers !

/*
MKtlDesc.loadDescs("*trol"); MKtl(\nk).free; MKtl(\nk, "*trol").gui;
*/


(
deviceName: "nanoKONTROL",
protocol: \midi,
deviceType: \faderbox,
elementTypes: [\fader, \knob, \button],
status: (
	linux: "tested and working",
	osx: "tested and working, 15.3.2016 by LFSaw.de",
	win: "unknown"),

idInfo: "nanoKONTROL",

hardwarePages: [1, 2, 3, 4],

deviceInfo: (
	vendorURI: "http://www.korg.com/us/products/controllers/nanokontrol/",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",
	longName: "KORG nanoKONTROL"
),
elementsDesc: (
	elements: [
		// transport is the same in all scenes:
		(
			key: \tr,
			shared: (\midiMsgType: \cc, \elementType: \button, \midiChan: 0,
				\spec: \midiBut, \mode: \push),
			elements: [
				(key: \rew, \midiNum: 47, style: (\row: 1.5, \showLabel: true )),
				(key: \play, \midiNum: 45, style: (\showLabel: true )),
				(key: \fwd, \midiNum: 48, style: (\showLabel: true )),
				(key: \loop, \midiNum: 49, style: (\row: 2.5, column:0, \showLabel: true )),
				(key: \stop, \midiNum: 46, style: ( \showLabel: true )),
				(key: \rec, \midiNum: 44, style: ( \showLabel: true ))
			]
		),
		(
			key: \kn,
			elements: [
				[ (14..22), 0 ! 9 ],
				[ (57..63)++[65,66],  0 ! 9 ],
				[ (94..97)++(102..106), 0 ! 9 ],
				[ 10 ! 9, (0..8) ]
			].collect { |page, iii|
				(
					shared: (\midiMsgType: \cc, \elementType: \knob, \spec: \midiCC),
					elements: page.flop.collect { |xs, i|
						(\midiChan: xs[1], \midiNum: xs[0],
							\style: ( \row: 0, \column: (i*2) + 4 ), \page: iii )
				})
			}
		),
		(
			key: \bt,
			elements: [
				[ [(23..31), 0 ! 9 ], [(33..41), 0 ! 9 ]],
				[ [(67..75), 0 ! 9 ], [(76..84), 0 ! 9 ]],
				[ [(107..115), 0 ! 9 ], [(116..124), 0 ! 9 ]],
				[ [16 ! 9, [16]++(1..8)], [ 17 ! 9, (0..8) ]]
			].collect { |page, iii|
				(
					shared: (\midiMsgType: \cc, \elementType: \button, \spec: \midiBut),
					elements: page.collect { |row, ii|
						(elements: row.flop.collect { |xs, i|
							(\midiChan: xs[1], \midiNum:  xs[0],
								\style: ( \row: [1.25,2.75][ii],
									\column: (i*2) + 3,
									width: 1.4,
									showLabel: true
								),
								\page: iii )
						})
				})
			}
		),
		(
			key: \sl,
			elements: [
				[ (2..6)++[8,9]++[12,13], 0 ! 9 ],
				[ [42,43]++(50..56),  0 ! 9 ],
				[ (85..93), 0 ! 9 ],
				[ 7 ! 9, (0..8) ]
			].collect { |page, iii|
				(
					shared: (\midiMsgType: \cc, \elementType: \slider,\spec: \midiCC),
					elements: page.flop.collect { |xs, i|
						(\midiChan: xs[1], \midiNum: xs[0],
							\style: ( \row: 1, \column: (i*2) + 4 ), \page: iii )
				})
			},
		)
	]
)
)