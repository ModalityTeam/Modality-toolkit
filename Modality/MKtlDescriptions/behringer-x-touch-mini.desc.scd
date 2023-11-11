/****

2 layers

LEDs are not divided in layers, but remember state last set while in layer.
Encoder ring displays are not remembered upon layer change.


m = MKtl( 'xtouch', "behringer-x-touch-mini" );
m.gui;

m.elements;

// MODE
m.elAt( \mode ).value_(1); // MC mode: this actually will make the device behave in a different mode, which is not yet mapped out with this spec
m.elAt( \mode ).value_(0); // regular mode


// LAYER
m.elAt( \layer ).value_(0); // layer A // has no function in MC mode
m.elAt( \layer ).value_(1); // layer B // has no function in MC mode

// LED control
m.elAt( \led ).value_(1); // on
m.elAt( \led ).value_(2); // blink
m.elAt( \led ).value_(0); // off

m.elAt( \led, \1 ).value_(1); // on
m.elAt( \led, \1 ).value_(2); // blink
m.elAt( \led, \1 ).value_(0); // off

m.elAt( \led, \1, \A ).value_(1); //on
m.elAt( \led, \1, \A ).value_(2); //blink
m.elAt( \led, \1, \A ).value_(0); //off

m.elAt( \led, \1, \B ).value_(1); //on
m.elAt( \led, \8, \B ).value_(2); //blink
m.elAt( \led, \8, \B ).value_(0); //off


// RING control:
// mode affects how encoder value is reflected on the ring
// single: 0, pan: 1, fan: 2, spread: 3, trim: 4
m.elAt( \ring, \mode ).value_(0); // single mode
m.elAt( \ring, \mode ).value_(1); // pan mode
m.elAt( \ring, \mode ).value_(2); // fan mode
m.elAt( \ring, \mode ).value_(3); // spread mode
m.elAt( \ring, \mode ).value_(4); // trim mode

// segment controls which segments are on: but only on at a time can be controlled, or all

Tdef( \testRingSeg, { 127.do{ |it| m.elAt( \ring, \seg ).value_( it.postln ); 1.0.wait; } } ).play

m.elAt( \ring, \seg ).value_( 0 ); // off
m.elAt( \ring, \seg ).value_( 27 ); // all on
m.elAt( \ring, \seg ).value_( 28 ); // all blinking

// 0..13: segment number
m.elAt( \ring, \seg ).value_( 4 ); // segnumber

// 14..26: segment number blinking
m.elAt( \ring, \seg ).value_( 6 + 13 ); // segnumber


m.elAt( \ring, \mode, \8 ).value_(3); // single mode

m.elAt( \ring, \seg, \8 ).value_( 3 ); // segnumber


TODO:
x add layer for MC mode to have relative encoders

- on macOS, device LED updates are slow, almost 1 sec delay - why?
-- layer switching shows very late on device
-- clicking button LEDs on gui only shows late on device
-- led rings around encoders : only mode shown, not value?

****/
// thisProcess.nowExecutingPath.postcs;

(
deviceName: "X-TOUCH MINI",
protocol: 'midi',
deviceType: 'mixer',
elementTypes: [ \encoder, \fader, \button ],
status: (
	linux: "tested and working, except for MC mode; 25-05-2017 by nescivi",
	osx: "unknown",
	win: "unknown"),

idInfo: "X-TOUCH MINI",

hardwarePages: [1, 2],

specs: (
	midiLedTri: IntegerClip.new( 0, 2, 0 ), // tristate led :  (off: 0, on: 1, blinking: 2)
	ringMode: IntegerClip(0,4), // single: 0, pan: 1, fan: 2, spread: 3, trim: 4
	ringVal: IntegerClip.new(0,28), // output has a particular meaning, see example above
	modeSpec: [0,1,\linear,1].asSpec, // 0 or 1

	// for relative encoders in MC mode:
	relEnc: (minval: -64, maxval: 64,
		asSpec: {|dict| dict },
		map: { |spec, val = 0| val.linlin(0, 1, spec.minval, spec.maxval).round.asInteger },
		unmap: { |spec, val = 0|
			val = min(64 - val, val);
			val.linlin(spec.minval, spec.maxval, 0, 1);
		},
		default: 0
	)
).postcs,

deviceInfo: (
	vendorURI: "http://www.music-group.com/Categories/Behringer/Computer-Audio/Desktop-Controllers/X-TOUCH-MINI/p/P0B3M",
	manualURI: "https://media.music-group.com/media/PLM/data/docs/P0B3M/X-TOUCH%20MINI_QSG_WW.pdf",
	// description: "",
	features: [
		"1 touch sensitive motor-faders",
		"8 rotary-encoder",
		"16 Buttons"
	],
	notes: "The description only maps the regular mode",
	longName: "Behringer X Touch Mini"
),

elementsDesc: (
	// key: \lyr,
	elements: 2.collect{ |lyr|
		(
			key: [\A,\B].at(lyr),
			shared: ( \page: lyr, midiChan: 10, ioType: \in ),
			elements: [
				( // channel faders
					key: \chan,
					elements: 8.collect{ |i|
						(
							elements: [
								(
									key: \bt,
									elements: [\A,\B].collect{ |jt,j|
										(
											key: jt,
											groupType: \noteOnOff,
											shared: (
												spec: \midiBut,
												elementType: \button,
												mode: \push,
												midiNum: (lyr*24) + 8 + i + (j*8),
												style: ( row: 4+j, column: i ),
												label: (jt++(i+1))
											)
										)
									}
								),
								(
									key: \enc,
									shared: (
										label: ("enc"++(i+1) )
									),
									elements: [
										(
											// key: \kn,
											key: (i+1).asSymbol,
											midiMsgType: \cc, spec: \midiCC,
											elementType: \encoder,
											midiNum: i+1 +(lyr*10),
											style: ( row: 3, column: i ),
										),
										(
											key: (i+1).asSymbol,
											groupType: \noteOnOff,
											shared: (
												spec: \midiBut, mode: \push,
												elementType: \button,
												// elementType: \encoderButton,
												midiNum: i + (lyr*24),
												style: ( row: 2, column: i )
											)
										)
									]
								),
							]
						)
					}
				),
				( // master fader strip
					key: \sl,
					midiMsgType: \cc, spec: \midiCC,
					elementType: \slider,
					midiNum: 9+lyr,
					label: 'master',
					style: ( row: 2, column: 8, height: 4 )
				)
			]
		)
	}
	++
	////// MC Mode:
	[
		(
			key: \MC,
			shared: ( \page: 2, midiChan: 0, ioType: \in ),
			elements: [
				( // channel faders
					key: \chan,
					elements: 8.collect{ |i|
						(
							elements: [
								(
									key: \bt,
									elements: [\A,\B].collect{ |jt,j|
										(
											key: jt,
											groupType: \noteOnOff,
											shared: (
												spec: \midiBut,
												elementType: \button,
												mode: \push,
												midiNum: [
													[89, 90, 40, 41, 42, 43, 44, 45],
													[87, 88, 91, 92, 86, 93, 94, 95],
												][j][i],
												style: ( row: 4+j, column: i ),
												label: (jt++(i+1))
											)
										)
									}
								),
								(
									key: \enc,
									shared: (
										label: ("enc"++(i+1) )
									),
									elements: [
										(
											// the encoder,
											key: (i+1).asSymbol,
											midiMsgType: \cc,
											spec: \relEnc,
											elementType: \encoder,
											midiNum: 16 + i,
											style: ( row: 3, column: i ),
										),
										(
											// the hat knob
											key: (i+1).asSymbol,
											groupType: \noteOnOff,
											shared: (
												spec: \midiBut, mode: \push,
												elementType: \button,
												// elementType: \encoderButton,
												midiNum: 32 + i,
												style: ( row: 2, column: i )
											)
										)
									]
								),
							]
						)
					}
				),
				( // master fader strip
					key: \sl,
					midiMsgType: \bend, spec: \midiBend,
					elementType: \slider,
					midiChan: 8,
					label: 'master',
					style: ( row: 2, column: 8, height: 4 )
				)
			]
		)
	]
	++
	// output
	[
		(
			ioType: \out,
			key: \mode,
			midiMsgType: \control,
			spec: \modeSpec,
			elementType: \led,
			midiNum: 127, midiChan: 0,
			style: ( row: 3, column: 9 )
		),
		(
			ioType: \out,
			key: \layer,
			midiMsgType: \program,
			elementType: \led,
			spec: \modeSpec,
			midiNum: 127, midiChan: 0,
			style: ( row: 4, column: 9 )
		),
		(
			key: \ring,
			shared: ( midiMsgType: \control, midiChan: 0, ioType: \out ),
			elements:
			[\mode,\seg].collect{ |ky,j|
				(
					key: ky,
					elements: 8.collect{ |i|
						(
							key: (i+1).asSymbol,
							midiNum: i+1+(j*8),
							spec: [\ringMode,\ringVal].at(j),
							style: ( row: j, column: i ),
						)
					};
				)
			};
		),
		(
			key: \led,
			shared: ( midiMsgType: \noteOn, midiChan: 0, spec: \midiLedTri, ioType: \out, elementType: \led ),
			elements: 8.collect{ |i|
				(
					key: (i+1).asSymbol,
					elements: [ \A,\B ].collect{ |ky,j|
						(
							key: ky,
							midiNum: i+(j*8),
							style: ( row: 6+j, column: i ),
						)
					}
				)
			}
		)
	]
);
);
