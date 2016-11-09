// user: channel 0
// factory: channel 8

/**** to do:

// micro example:
m = MKtl('myXL', "novation-launchcontrol-xl");
g = MKtl('myXL').gui;
MKtl('myXL').trace;
MKtl('myXL').elAt(\pg0, \sl).action = { "YO, sl!".postln };


****/

(
deviceName: "Launch Control XL",
protocol: \midi,
deviceType: \mixer,
elementTypes: [\fader, \button, \knob],
status: (
	linux: "unknown",
	osx: "tested and working, 15.3.2016 by LFSaw.de",
	win: "unknown"),

idInfo: "Launch Control XL",

hardwarePages: (
	factory: [1,2,3,4,5,6,7,8],
	user: [1,2,3,4,5,6,7,8]
),

deviceInfo: (
	// vendorURI: "http://global.novationmusic.com/launch/launch-control-xl",
	// manualURI: "http://global.novationmusic.com/support/product-downloads?product=Launch+Control+XL",
	description: "A faderbox emulating the interface of a mixing desk",
	features: [
		"24 rotary pots, each with 300 degree motion and 2-colour LED",
		"8 Faders (60mm)",
		"16 multi-colour backlit buttons",
		"8 backlit buttons",
		"8 “user”-pages + 8 “factory”-pages",
	],
	// notes: "",
	longName: "novation launchcontrol XL"
),
elementsDesc: (

	elements: 16.collect { |chan|
		(
			key: ("pg" ++ chan).asSymbol,
			shared: ('midiChan': chan, \page: chan),
			elements: [
				(
					key: \kn,
					shared: ('midiMsgType': 'cc', 'elementType': 'knob',
						'spec': 'midiCC', \ioType: \inout),
					elements: [
						(
							key: 'sndA',
							elements: (13..20).collect { |num| ('midiNum':  num) }
						),
						(
							key: 'sndB',
							elements: (29..36).collect { |num| ('midiNum':  num) }
						),
						(
							key: 'pan',
							elements: (49..56).collect { |num| ('midiNum':  num) }
						)
					]
				),
				(
					key: 'sl',
					shared: (elementType: \slider, midiMsgType: \cc,
						spec: \midiCC, \style: ( height: 4 )),
					elements: (77..84).collect { |num, i|
						('midiNum':  num, \style: ( column: i, height: 4 ))
					}
				),
				(
					key: \bt,
					shared: ('elementType': 'pad', groupType: \noteOnOffBut,
						'spec': 'midiNote', \ioType: \inout),
					elements: [
						(
							key: 'fcs',
							shared: ('elementType': 'pad', 'spec': 'midiNote', \ioType: \inout),
							elements: ((41..44) ++ (57..60)).collect{|num, i|

								(
									key: (i+1).asSymbol, midiNum: num,
									shared:(
										style: (
											row: 7,
											column: i
										)
								))
							}

						),
						(
							key: 'ctl',
							shared: ('elementType': 'pad', groupType: \noteOnOffBut,
								'spec': 'midiNote', \ioType: \inout),
							elements:  ((73..76) ++ (89..92)).collect { |num, i|
								(
									key: (i+1).asSymbol, midiNum: num,
									shared:(
										style: ( row: 8, column: i )
									)
								)
							}

						)
					]
				),

				(
					key: \slct,
					shared: ('elementType': 'pad', groupType: \noteOnOffBut,
						'spec': 'midiNote', \ioType: \inout),
					elements: [
						[ \device, 105, 3, 8.5 ],
						[ \mute,   106, 4, 8.5 ],
						[ \solo,   107, 5, 8.5 ],
						[ \arm,    108, 6, 8.5 ]
					].collect{|list|
						var key, num, row, col;
						#key, num, row, col = list;
						(
							key: key, midiNum: num,
							shared: (style: (row: row, column: col ))
						)
					}
				),

				(
					key: \nav,
					shared: ('elementType': 'button', 'spec': 'midiCC', midiMsgType: \cc, \ioType: \inout),
					elements: [
						[ \up,     104, 1, 8 ],
						[ \down,   105, 1, 9 ],
						[ \left,   106, 2, 8 ],
						[ \right,  107, 2, 9 ],
					].collect{|list|
						var key, num, row, col;
						#key, num, row, col = list;

						(
							'key': key,
							'midiNum': num,
							'style':  (row: row, column: col )
						)

					}

				)
			]
		)
	}
)
);


				// // check this when enabling it
				// [	// key, midinum, row, col
				// 	[ \up,     104, 1, 8 ],
				// 	[ \down,   105, 1, 9 ],
				// 	[ \left,   106, 2, 8 ],
				// 	[ \right,  107, 2, 9 ],
				//
				// 	[ \device, 105, 3, 8.5 ],
				// 	[ \mute,   106, 4, 8.5 ],
				// 	[ \solo,   107, 5, 8.5 ],
				// 	[ \arm,    108, 6, 8.5 ]
				//
				// ].collect { |list|
				// 	var onOffGroup, style;
				// 	var key, num, row, col;
				//
				// 	#key, num, row, col = list;
				// 	style = (row: row, column: col);
				//
				// 	onOffGroup = (key: key, midiNum: num).postcs;
				// 	// onOffGroup.elements[0].put(\style, style);
				// 	// onOffGroup.elements[0].put(\style,
				// 	// 	style.copy.put(\row, style.row + 0.8)
				// 	// );
				// 	onOffGroup
				// }
