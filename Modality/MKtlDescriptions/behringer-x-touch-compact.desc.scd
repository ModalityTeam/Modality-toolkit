/****

2 layers
touch
motorized control

m = MKtl('btouch', "behringer-x-touch-compact");
m.gui;

m.elements

// output

m.elAt( \mode ).value_( 1 ); // mackie mode (not mapped)
m.elAt( \mode ).value_( 0 ); // standard mode

m.elAt( \layer ).value_( 1 ); // B
m.elAt( \layer ).value_( 0 ); // A

m.elAt( \foot ).value_( 1 )
m.elAt( \foot ).value_( 0 )

m.elAt( \expr ).value_( 1 ); // only a trigger to flash
m.elAt( \expr ).value_( 0 ); // only a trigger to flash

// faders are a bit weird - when set through external midi, the state of the layers is not kept

m.elAt( \out, \master, \mc ).value_(0) // off
m.elAt( \out, \master, \mc ).value_(1) // off
m.elAt( \out, \master, \mc ).value_(2) // on

m.elAt( \out, \master, \sl ).value_(0)
m.elAt( \out, \master, \sl ).value_(1)
m.elAt( \out, \master, \sl ).value_(0.5)


m.elAt( \out, \chan, \1, \mc ).value_( 2 );
m.elAt( \out, \chan, \1, \mc ).value_( 0 );

m.elAt( \out, \chan, \1, \sl ).value_( 1 );
m.elAt( \out, \chan, \1, \sl ).value_( 0.5 );
m.elAt( \out, \chan, \1, \sl ).value_( 0 );


****/
// a =
(
deviceName: "X-TOUCH COMPACT",
protocol: 'midi',
deviceType: 'mixer',
elementTypes: [ \encoder, \fader, \button ],
status: (
	linux: "tested and working, except for mackie mode; 25-05-2017 by nescivi",
	osx: "unknown",
	win: "unknown"),

idInfo: "X-TOUCH COMPACT",

hardwarePages: [1, 2],

specs:(
	midiLedTri: IntegerClip.new( 0, 2, 0 ), // tristate led :  (off: 0, on: 1, blinking: 2)
	ringMode: IntegerClip(0,4), // single: 0, pan: 1, fan: 2, spread: 3, trim: 4
	ringVal: IntegerClip.new(0,28), // output has a particular meaning, see example above
	modeSpec: [0,1,\linear,1].asSpec // 0 or 1
),

deviceInfo: (
	vendorURI: "http://www.music-group.com/Categories/Behringer/Computer-Audio/Desktop-Controllers/X-TOUCH-COMPACT/p/P0B3L#",
	manualURI: "http://media.music-group.com/media/PLM/data/docs/P0B3L/X-TOUCH%20COMPACT_QSG_WW.pdf",
	// description: "",
	features: [
		"9 touch sensitive motor-faders",
		"16 rotary-encoder",
		"36 Buttons"
	],
	notes: "This description covers the regular mode",
	longName: "Behringer X Touch Compact"
),

elementsDesc: (
	elements: 2.collect{ |lyr|
		(
			// key: \lyr,
			shared: ( \page: lyr, midiChan: 0, ioType: \inout ),
			elements: [
				(
					key: \pdl,
					shared: ( midiMsgType: \cc, elementType: \pedal, spec: \midiCC ),
					elements: [
						(
							key: \foot,
							midiNum: [ 27, 64 ].at(lyr),
							style: ( row: 6, column: 11, height: 4 ),
							label: "foot"
						),
						(
							key: \expr,
							midiNum: [ 26, 63 ].at(lyr),
							style: ( row: 6, column: 12, height: 4 ),
							label: "expr"
						)
					];
				),
				( // channel faders
					key: \chan,
					elements: 8.collect{ |i|
						(
							elements: [
								(
									groupType: \noteOnOff,
									key: \mc,
									shared: (
										spec: \midiBut,
										elementType: \button,
										mode: \push,
										midiNum: i + [ 40, 95 ].at(lyr),
										style: ( row: 10, column: i ),
										label: ("mc"++(i+1) )
									)
								),
								(
									midiMsgType: \cc, spec: \midiCC,
									key: \sl,
									elementType: \slider,
									midiNum: i + [ 1, 28 ].at(lyr),
									style: ( row: 6, column: i, height: 4 ),
									label: ("sl"++(i+1) )
								),
								(
									midiMsgType: \cc, spec: \midiCC,
									key: \tch,
									elementType: \touch, // \chanTouch ?
									midiNum: i + [ 101, 111 ].at(lyr),
									label: ("tch"++(i+1) ),
									style: ( row: 5, column: i )
								),
								// only for channel 1 to 8
								(
									key: \bt,
									elements: 3.collect{ |jt|
										(
											groupType: \noteOnOff,
											shared: (
												spec: \midiBut,
												elementType: \button,
												mode: \push,
												midiNum: [16,71].at(lyr) + (jt*8) + i, // 71,79,87
												style: ( row: 2+jt, column: i ),
												label: ("bt"++(i+1)++"_"++(jt+1))
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
											midiMsgType: \cc, spec: \midiCC,
											elementType: \encoder,
											midiNum: i + [ 10, 37 ].at(lyr),
											style: ( row: 1, column: i ),
										),
										(
											// key: \bt,
											groupType: \noteOnOff,
											shared: (
												spec: \midiBut, mode: \push,
												elementType: \button,
												// elementType: \encoderButton,
												midiNum: [ 0, 55 ].at( lyr ) + i,
												style: ( row: 0, column: i )
											)
										)
									]
								),
							]
						)
					}
				),
				( // master fader strip
					key: \master,
					elements: [
						(
							groupType: \noteOnOff,
							key: \mc,
							shared: (
								spec: \midiBut,
								elementType: \button,
								mode: \push,
								midiNum: [48,103].at(lyr),
								label: 'mc_main',
								style: ( row: 10, column: 8 )
							)
						),
						(
							midiMsgType: \cc, spec: \midiCC,
							key: \sl,
							elementType: \slider,
							midiNum: [9, 36].at(lyr),
							label: 'sl_main',
							style: ( row: 6, column: 8, height: 4 )
						),
						(
							midiMsgType: \cc, spec: \midiCC,
							key: \tch,
							elementType: \touch,
							midiNum: [109, 119].at(lyr),
							label: 'tch_main',
							style: ( row: 5, column: 8 )
						)
					]
				),
				(
					key: \enc,
					shared: (elementType: \encoder ),
					elements: 8.collect{ |it|
						(
							shared: ( key: it+9,  midiMsgType: \cc, spec: \midiCC, label: ("enc"++(it+9) ) ),
							elements: [
								(
								midiNum: [18,45].at(lyr)+it, // 45
								style: ( row: (it/2).floor, column: 9 + (it%2 * 2) ),
							),
								(
									// key: \bt,
									groupType: \noteOnOff,
									shared: (
										spec: \midiBut, mode: \push, elementType: \button,
										midiNum: [ 8, 63 ].at( lyr ) + it,
									style: ( row: (it/2).floor, column: 9 + (it%2 * 2) + 1 ), // would be nicer if knob has a button press view
									// elementType: \encoderButton,
								)
							)
							]
						)
					};
				),
				(
					// transport controls
					key: \tr,
					shared: ( groupType: \noteOnOff, spec: \midiBut, elementType: \button, mode: \push ),
					elements: [
						( key: \rew,
							shared: (
								label: \rew, midiNum: [49,104].at(lyr),
								style: ( row: 7, column: 9 )
							)
						),
						( key: \fwd,
							shared: (
								label: \fwd, midiNum: [50,105].at(lyr),
								style: ( row: 7, column: 10 )
							)
						),
						( key: \loop,
							shared: (
								label: \loop, midiNum: [51,106].at(lyr),
								style: ( row: 8, column: 9 )
							)
						),
						( key: \rec,
							shared: (
								label: \rec, midiNum:  [52, 107].at(lyr),
								style: ( row: 8, column: 10 )
							)
						),
						( key: \stop,
							shared: (
								label: \stop, midiNum: [53, 108].at(lyr),
								style: ( row: 9, column: 9 )
							)
						),
						( key: \play,
							shared: (
								label: \play, midiNum: [54, 109].at(lyr),
								style: ( row: 9, column: 10 )
							)
						)
					]
				)
			]
		);
	} ++
	// output
	[
		(
			ioType: \out,
			key: \mode,
			midiMsgType: \control,
			spec: \modeSpec,
			elementType: \led,
			midiNum: 127, midiChan: 1,
			style: ( row: 3, column: 8 )
		),
		(
			ioType: \out,
			key: \layer,
			midiMsgType: \program,
			elementType: \led,
			spec: \modeSpec,
			midiNum: 127, midiChan: 1,
			style: ( row: 10, column: 9 )
		),
		(
			ioType: \out,
			midiMsgType: \cc, elementType: \led,
			spec: \midiBut,
			key: \foot,
			midiNum: 42, midiChan: 1,
			style: ( row: 1, column: 8 ),
			label: "foot"
		),
		(
			ioType: \out,
			midiMsgType: \cc, elementType: \led,
			spec: \midiCC,
			key: \expr,
			midiNum: 43, midiChan: 1,
			style: ( row: 2, column: 8 ),
			label: "expr"
		)
	] ++ [
		(
			key: \out,
			shared: ( ioType: \out, page: 2, midiChan: 1 ), // page not in hardware, just for GUI
			elements: [
			( // channel faders
				key: \chan,
				elements: 8.collect{ |i|
					(
						elements: [
							(
								midiMsgType: \noteOn,
								key: \mc,
								spec: \midiLedTri,
								elementType: \led,
								mode: \tristate,
								midiNum: (24..31).at(i),
								style: ( row: 10, column: i ),
								label: ("mc"++(i+1) ),
							),
							(
								midiMsgType: \cc,
								spec: \midiCC,
								key: \sl,
								elementType: \slider,
								midiNum: i+1,
								style: ( row: 6, column: i, height: 4 ),
								label: ("sl"++(i+1) )
							),
							// only for channel 1 to 8
							(
								key: \led,
								elements: 3.collect{ |jt|
									(
										midiMsgType: \noteOn,
										spec: \midiLedTri,
										elementType: \led,
										mode: \tristate,
										midiNum: i + (jt*8), // 71,79,87
										style: ( row: 2+jt, column: i ),
										label: ("ld"++(i+1)++"_"++(jt+1))
									)
								}
							),
							/*(
							key: \enc,
							shared: (
							label: ("enc"++(i+1) )
							),
							elements: [
							(
							// key: \kn,
							midiMsgType: \cc, spec: \midiCC,
							elementType: \encoder,
							midiNum: i + [ 10, 37 ].at(lyr),
							style: ( row: 1, column: i ),
							)
							]
								),*/
						]
					)
				}
			),
			( // master fader strip
				key: \master,
				elements: [
					(
						key: \mc,
						spec: \midiLedTri,
						midiMsgType: \noteOn,
						elementType: \led,
						mode: \tristate,
						midiNum: 32,
						label: 'mc_main',
						style: ( row: 10, column: 8 )
					),
					(
						midiMsgType: \cc, spec: \midiCC,
						key: \sl,
						elementType: \slider,
						midiNum: 9,
						label: 'sl_main',
						style: ( row: 6, column: 8, height: 4 )
					)
				]
			),
			// (
			// 	key: \enc,
			// 	shared: (elementType: \encoder ),
			// 	elements: 8.collect{ |it|
			// 		(
			// 			shared: ( key: it+9,  midiMsgType: \cc, spec: \midiCC, label: ("enc"++(it+9) ) ),
			// 			elements: [
			// 				(
			// 					midiNum: [18,45].at(lyr)+it, // 45
			// 					style: ( row: (it/2).floor, column: 9 + (it%2 * 2) ),
			// 				)
			// 			]
			// 		)
			// 	};
			// ),
				(
					// transport controls
					key: \tr,
					shared: ( midiMsgType: \noteOn, mode: \tristate, spec: \midiLedTri, elementType: \led ),
					elements: [
						(
							key: \rew, midiNum: 33,
							label: \rew, style: ( row: 7, column: 9 )
						),
						(
							key: \fwd, midiNum: 34,
							label: \fwd, style: ( row: 7, column: 10 )
						),
						(
							key: \loop, midiNum: 35,
							label: \loop, style: ( row: 8, column: 9 )
						),
						(
							key: \rec, midiNum: 36,
							label: \rec, style: ( row: 8, column: 10 )
						),
						(
							key: \stop, midiNum: 37,
							label: \stop, style: ( row: 9, column: 9 )
						),
						(
							key: \play, midiNum: 38,
							label: \play, style: ( row: 9, column: 10 )
						)
					]
				)
			]
		);
	]
);
);
