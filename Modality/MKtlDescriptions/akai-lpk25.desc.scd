/****

Akai LPK25 has one button that sends info: the sustain
the other buttons change octaves up and down -> which notes are sent out;
both up and down can be pressed multiple times to go further down or up.

With program pressed and then selecting a different program with the right keys, you change the MIDI channel.

And then there is an arpeggiator which allows to tap a tempo and then repeats note outputs.

****/

(
deviceName: "LPK25",
protocol: 'midi',
deviceType: 'midiKeyboard',
elementTypes: [ \pianoKey ],
status: (
	linux: "tested and working. 24-05-2017 by nescivi",
	osx: "unknown",
	win: "unknown"),

idInfo: "LPK25",

hardwarePages: [0,1, 2, 3],

testCode: {
	a = MKtl('lpk25', "akai-lpk25");
	a.elAt(\prog,0,\pkey,64).action = { |el ... groups|
		[el.name, el.value, "groups:", groups.collect(_.name)].postln;
	};
},

deviceInfo: (
	vendorURI: 'http://www.akaipro.com/product/lpk25',
	manualURI: 'http://www.akaipro.com/product/lpk25#downloads',
	// description: ,
	features: [
		"Velocity-sensitive mini-midiKeyboard",
		"Arpeggiator"
	],
	longName: "Akai LPK25"
	// notes: ,
	// hasScribble: false
),
elementsDesc: (
	key: \prog,
	shared: ( ioType: \in ),
	elements: (0..3).collect{ |page|
		(
			shared: ('midiChan': page ),
			elements: [
				(
					key: \pkey,
					shared: ('elementType': 'pianoKey', groupType: \noteOnOff, spec: \midiVel), // groupType: \noteOnOff,
					elements: (0..120).collect { |midinum,i|
						var pos = Piano.pos(midinum % 48, 0);
						(
							key: i.asSymbol,
							shared: (
								midiNum: midinum,
								style: (
									row: (4 - (i div: 48 * 2)) + (pos.y * 0.9) + 1,
									column: pos.x + 1,
									color: pos.color,
									height: 1.2
							)),
						);
					}
				),
				(
					key: 'sustain', 'midiNum':  64, 'midiMsgType': 'cc', 'elementType': 'button', 'spec': 'midiCC',
					style: ( row: 0, column: 0, height: 1)
				)
			]
		);
		}
	)
);
