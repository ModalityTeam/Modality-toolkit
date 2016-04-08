/* basic desc file for Beatstep default setup

See also rel0, rel-16 descs for relative control with examples.

MKtl('bs', "arturia-beatstep");
MKtl('bs').trace;


// TODO:
* setting an encoder to a value from SC,
    so encoder continues moving from there

MKtl('bs').elAt(\pg0, \kn, 0).value;
// set to a different value by program
MKtl('bs').elAt(\pg0, \kn, 0).value_(0.2);
// -> now moving knob 1 should continue from 25, and it does not yet.
// try sending directly - also no luck
MKtl('bs').device.midiOut.control(0, 10, 64);
// -> is out protocol  different?
// -> ask arturia about which ccnums to send back.

*/

(
deviceName: "Arturia BeatStep",
protocol: \midi,
deviceType: \multiController,
elementTypes: [\encoder, \button],
status: (
	linux: "unknown",
	osx: "tested and working. 2015-03-15, adc",
	win: "unknown"),

idInfo: "Arturia BeatStep",

deviceInfo: (
	vendorURI: "https://www.arturia.com/products/hybrid-synths/beatstep",
	manualURI: "http://downloads.arturia.com/products/beatstep/manual/BeatStep_Manual_1_0_1_EN.pdf",
	// description: "",
	features: [
		"16 drum pads with velocity and polyphonic aftertouch",
		"16 rotary encoders; supporting absolute and dec/inc mode",
		"1  BIG rotary encoder; supporting absolute and dec/inc mode",
		"2  Buttons: play, pause, that send MMC by default",
	],
	// description: "A controller",
	notes: "Basic Desc file for default setup",
	longName: "Arturia Beatstep (Basic)."
),

elementsDesc: (
	elements: (0..15).collect { |chan, i|
		(
			key: "pg%".format(i).asSymbol,
			shared: (midiChan: chan, page: i),

			elements: [
		(
			key: \stop,
			shared: (elementType: 'button', midiNum: 1, spec: \midiBut),
			elements: [
				(
					key: \on, midiMsgType: 'noteOn',
					style: (row: 2, column: 0, height: 0.5, showLabel: true)
				),
				(
					key: \off, midiMsgType: 'noteOff',
					style: (row: 2.5, column: 0, height: 0.5, showLabel: true)
				)
			],
		),
		(
			key: \play,
			shared: (elementType: 'button', midiNum: 2, spec: \midiBut),
			elements: [
				(
					key: \on, midiMsgType: 'noteOn',
					style: (row: 2.0, column: 1, height: 0.5, showLabel: true)
				),
				(
					key: \off, midiMsgType: 'noteOff',
					style: (row: 2.5, column: 1, height: 0.5, showLabel: true)
				)
			],
		),

		(
			key: \pad,
			shared: (elementType: 'pad', spec: 'midiVel'),
			elements: (36 + ((8..15)++(0..7))).collect { |num,i|
				(
					shared: (midiNum: num),
					elements: [
						(
							key: \on, midiMsgType: \noteOn,
							style: (row: (i div: 8 * 2 + 2), column: i % 8 + 2,
								height: 0.5, showLabel: true)
						),
						(
							key: \off, midiMsgType: \noteOff,
							style: (row: (i div: 8 * 2 + 2.5), column: i % 8 + 2,
								height: 0.5, showLabel: true)
						),
						(
							key: \touch, midiMsgType: \polytouch,
							style: (row: (i div: 8 * 2 + 3), column: i % 8 + 2,
								height: 0.5, showLabel: true)
						)
					]
				)
			}
		),
		(
			// default - absolute values
			key: \kn,
			shared: (midiMsgType: 'cc', elementType: 'encoder',
				spec: 'midiCC', ioType: \inout),
			elements: [
				[ 10, 74, 71, 76, 77, 93, 73, 75],
				[114, 18, 19, 16, 17, 91, 79, 72]
			].flat.collect { |num, i|
				( midiNum:  num,
					style: (row: (i div: 8), column: i % 8 + 2, showLabel: true)
				)
			}

		),
		(
			// default - absolute value
			key: \bigKnob, midiMsgType: 'cc', elementType: 'encoder',
			spec: 'midiCC',
			midiNum: 7,  // big knob
			style: (row: 0, column: 0, height: 2, showLabel: true)
		)
			]
		)
	}
)
)
