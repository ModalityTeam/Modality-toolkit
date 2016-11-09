/****
Novation Launch Control

minimal code examples for testing, such as:

k = MKtl('nlc', "novation-launchcontrol");
k.elementAt(0, \kn, 0).action = { \yo.postln; };
k.elementAt(0, \kn, 1).action = { 1.postcs; };
k.gui;




****/

(
deviceName: "Launch Control",
protocol: \midi,
deviceType: \mixer,
elementTypes: [\button, \knob],
status: (
	linux: "unknown",
	osx: "tested and working, 15.3.2016 by LFSaw.de",
	win: "unknown"),

idInfo: "Launch Control",

hardwarePages: (
	factory: [1,2,3,4,5,6,7,8],
	user: [1,2,3,4,5,6,7,8]
),

deviceInfo: (
	// vendorURI: "http://global.novationmusic.com/launch/launch-control",
	// manualURI: "http://global.novationmusic.com/support/product-downloads?product=Launch+Control",
	description: "A rotary box emulating the interface of a mixing desk",
	features: [
		"16 rotary pots, each with 300 degree motion",
		"8 multi-colour backlit buttons",
		"8 “user”-pages + 8 “factory”-pages",
	],
	// notes: "",
	longName: "novation launchcontrol"
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
							elements: (21..28).collect { |num| ('midiNum':  num) }
						),
						(
							key: 'sndB',
							elements: (41..48).collect { |num| ('midiNum':  num) }
						)
					]
				),
				(
					key: \bt,
					shared: ('elementType': 'pad', 'spec': 'midiNote', \ioType: \inout),
					elements: ((9..12) ++ (25..28)).collect{|num, i|
						(
							key: (i+1).asSymbol, midiNum: num,
							groupType: \noteOnOffBut,
							shared: (
								style: ( row: 2, column: i )
							)
						)
					}

				),
				(
					key: \nav,
					shared: ('elementType': 'button', 'spec': 'midiCC', midiMsgType: \cc, \ioType: \inout),
					elements: [
						[ \up,     114, 1, 8 ],
						[ \down,   115, 1, 9 ],
						[ \left,   116, 2, 8 ],
						[ \right,  117, 2, 9 ],
					].collect{|list|
						var key, num, row, col;
						#key, num, row, col = list;

						(
							'key': key,
							'midiNum': num,
							'style':  (row: row, column: col)
						)

					}

				)
			]
		)
	}
)

);

