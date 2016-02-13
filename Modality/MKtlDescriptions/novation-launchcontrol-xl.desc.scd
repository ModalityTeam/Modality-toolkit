// user: channel 0
// factory: channel 8

/**** to do:
* check  overlap of midiNum with device/down, mute/left!
* fix missing right-side buttons

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
	osx: "unknown",
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
	// hasScribble: false
),
elementsDesc: (

	elements: 16.collect { |chan|
		(
			key: ("pg" ++ chan).asSymbol,
			shared: ('midiChan': chan, \page: chan),
			elements: [
				(
					key: \kn,
					shared: ('midiMsgType': 'cc', 'type': 'knob',
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
							key: 'knPan',
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
					shared: ('elementType': 'button', 'spec': 'midiBut', \ioType: \inout),
					elements: [
						(
							key: 'fcs',
							shared: ('midiMsgType': 'cc'),
							elements: ((41..44) ++ (57..60)).collect { |num| ('midiNum':  num) }
						),
						(
							key: 'ctl',
							shared: ('midiMsgType': 'cc'),
							elements: ((73..76) ++ (89..92)).collect { |num| ('midiNum':  num) }
						)
					]
				),

				(
					key: \slct,
					shared: ('type': 'button', 'spec': 'midiNote', \ioType: \inout),
					elements: [
						MKtlDesc.notePair(\device, 105),
						MKtlDesc.notePair(\mute, 106),
						MKtlDesc.notePair(\solo, 107),
						MKtlDesc.notePair(\arm, 108)
					]
				),

				(
					key: \nav,
					shared: ('type': 'button', 'spec': 'midiCC', midiMsgType: \cc, \ioType: \inout),
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
							'style':  (row: row, column: col, \showLabel: true)
						)

					}

				)


				//
				// 	[	// key, midinum, row, col
				// 		[ \up,     104, 1, 8 ],
				// 		[ \down,   105, 1, 9 ],
				// 		[ \left,   106, 2, 8 ],
				// 		[ \right,  107, 2, 9 ],
				//
				// 		[ \device, 105, 3, 8.5 ],
				// 		[ \mute,   106, 4, 8.5 ],
				// 		[ \solo,   107, 5, 8.5 ],
				// 		[ \arm,    108, 6, 8.5 ]
				//
				// 	].collect { |list|
				// 		var onOffGroup, style;
				// 		var key, num, row, col;
				//
				// 		#key, num, row, col = list;
				// 		style = (row: row, column: col, \showLabel: true);
				//
				// 		onOffGroup = MKtlDesc.notePair(key, num).postcs;
				// 		// onOffGroup.elements[0].put(\style, style);
				// 		// onOffGroup.elements[0].put(\style,
				// 		// 	style.copy.put(\row, style.row + 0.8)
				// 		// );
				// 		onOffGroup
				// 	}
				// )
			]
		)
	}
)
);
