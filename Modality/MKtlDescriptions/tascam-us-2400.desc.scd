// Tascam US-2400
/*

* meter button only sends a 127 value: so we need a trigger type, it also has a side effect for the encoder led indicators to be used as meter outputs


MKtl('tascam', "tascam-us-2400",multiIndex:0);
MKtl('tascam').gui;

MKtl('tascam').trace;

MKtl('tascam').elAt(\sec,0,\led, \sel, 1 ).value_(0) // off
MKtl('tascam').elAt(\sec,0,\led, \sel, 1 ).value_(1) // blinking
MKtl('tascam').elAt(\sec,0,\led, \sel, 1 ).value_(2) // on

MKtl('tascam').elAt(\sec,0,\led, \solo, 1 ).value_(0) // off
MKtl('tascam').elAt(\sec,0,\led, \solo, 1 ).value_(1) // blinking
MKtl('tascam').elAt(\sec,0,\led, \solo, 1 ).value_(2) // on

MKtl('tascam').elAt(\sec,0,\led, \mute, 1 ).value_(0) // off
MKtl('tascam').elAt(\sec,0,\led, \mute, 1 ).value_(1) // blinking
MKtl('tascam').elAt(\sec,0,\led, \mute, 1 ).value_(2) // on

MKtl('tascam').elAt(\mst,\led,\sel ).value_(0);
MKtl('tascam').elAt(\mst,\led,\sel ).value_(1);
MKtl('tascam').elAt(\mst,\led,\sel ).value_(2);

MKtl('tascam').elAt(\mst,\led,\clr ).value_(0);
MKtl('tascam').elAt(\mst,\led,\clr ).value_(1);
MKtl('tascam').elAt(\mst,\led,\clr ).value_(2);

MKtl('tascam').elAt(\mst,\led,\flip ).value_(0);
MKtl('tascam').elAt(\mst,\led,\flip ).value_(1);
MKtl('tascam').elAt(\mst,\led,\flip ).value_(2);


MKtl('tascam').elAt(\ctl,\led,\fwd).value_(0);
MKtl('tascam').elAt(\ctl,\led,\fwd ).value_(1);
MKtl('tascam').elAt(\ctl,\led,\fwd ).value_(2);

MKtl('tascam').elAt(\ctl,\led,\chan).value_(0);
MKtl('tascam').elAt(\ctl,\led,\chan ).value_(1);
MKtl('tascam').elAt(\ctl,\led,\chan ).value_(2);

MKtl('tascam').elAt(\ctl,\led,\mtr).value_(0);
MKtl('tascam').elAt(\ctl,\led,\mtr ).value_(1);
MKtl('tascam').elAt(\ctl,\led,\mtr ).value_(2);



// faders
MKtl('tascam').elAt(\sec,0,\sl,0).value_( 1 );
MKtl('tascam').elAt(\sec,2,\sl,0).value_( 1 );
MKtl('tascam').elAt(\mst,\sl).value_( 1 );
MKtl('tascam').elAt(\mst,\sl).value_( 0.2 );


// meters

These have a particular way of using the bits:
(
~levelSpec = [0,15,\linear,1].asSpec;
~meterVal = { |level, showPeak=false, resetOverload = false, overload=false|
	level = ~levelSpec.map( level );
	level = level.asInteger & 0x0F;
	if ( showPeak ){
		level = level | 0x10;
	};
	if ( resetOverload ){
		level = level | 0x40; // reset the overload
		if ( overload ){
			level = level | 0x20; // there is an overload
		};
	};
	level.postln;
};
);

~meterVal.value( 1 ); // no peak
~meterVal.value( 1, true ); // with peak
~meterVal.value( 1, true, true, true ); // with peak, and overload

~meterVal.value( 1, true, true, false ); // with peak, and no overload
~meterVal.value( 1, true, false ); // with peak, and no overload

MKtl('tascam').elAt(\sec,0,\mtr, 0 ).value_( ~meterVal.value( 0.4, false ) ); // don't set peak
MKtl('tascam').elAt(\sec,0,\mtr, 0 ).value_( ~meterVal.value( 0.4, true ) ); // set peak
MKtl('tascam').elAt(\sec,0,\mtr, 0 ).value_( ~meterVal.value( 1, true, true, true ) ); // set overload
MKtl('tascam').elAt(\sec,0,\mtr, 0 ).value_( ~meterVal.value( 0.5, true, false ) ); // don't change overload
MKtl('tascam').elAt(\sec,0,\mtr, 0 ).value_( ~meterVal.value( 0.5, true, true, false ) ); // clear overload



(
~levelSpec = [0,15,\linear,1].asSpec;
~ringVal = { |level, mode=1, center=false|
	level = ~levelSpec.map( level );
	level = level.asInteger & 0x0F;
	if ( center ){
		level = level | 0x40;
	};
	switch( mode,
		// 1, { },    // data & 0x30 = 0
		// \dot, { }, // data & 0x30 = 0
		2, { level = level | 0x10; }, // data & 0x30 = 0x10
		\cutBoost, { level = level | 0x10; }, // data & 0x30 = 0x10
		3, { level = level | 0x10; }, // data & 0x30 = 0x20
		\spread, { level = level | 0x20; }, // data & 0x30 = 0x20
		4, {
			level = level | 0x10;
			level = level | 0x20;
		}, // data & 0x30 = 0x20
		\width, {
			level = level | 0x10;
			level = level | 0x20;
		} // data & 0x30 = 0x20
	);
	level.postln;
};
);

~ringVal.value( 0.5, \dot, true ); // no peak

MKtl('tascam').elAt(\sec,0,\ring, 0 ).value_( ~ringVal.value( 1, \dot ) ); // dot mode, no center

MKtl('tascam').elAt(\sec,0,\ring, 0 ).value_( ~ringVal.value( 0.5, \cutBoost ) ); // cut Boost mode, no center // mapping a little weird

MKtl('tascam').elAt(\sec,0,\ring, 0 ).value_( ~ringVal.value( 0.5, \width ) ); // width mode, no center // only goes up to 0.5

MKtl('tascam').elAt(\sec,0,\ring, 0 ).value_( ~ringVal.value( 0.5, \spread ) ); // spread mode, no center
MKtl('tascam').elAt(\sec,0,\ring, 0 ).value_( ~ringVal.value( 0.8, \spread ) ); // spread mode, no center
MKtl('tascam').elAt(\sec,0,\ring, 0 ).value_( ~ringVal.value( 0.2, \spread ) ); // spread mode, no center
MKtl('tascam').elAt(\sec,0,\ring, 0 ).value_( ~ringVal.value( 0.8, \spread, true ) ); // spread mode, center
MKtl('tascam').elAt(\sec,0,\ring, 0 ).value_( ~ringVal.value( 0.8, \spread, false ) ); // spread mode, no center


*/

(
deviceName: "US-2400",
protocol: 'midi',
deviceType: 'mixer',
elementTypes: [ \fader, \rotary, \button, \led, \meter, \jogWheel, \joyStick ],
status: (
	linux: "tested and working; 25-05-2017 by nescivi",
	osx: "unknown",
	win: "unknown"),

idInfo: "US-2400",

specs: (
	fader14bit: [0, 16384, \linear, 1, 0 ].asSpec,
	faderTascam: [0, 16368, \linear, 1, 0 ].asSpec,
	relativeTascam: IntegerClip.new( 0, 127, 64 ), // encoder spec
	meterTascam: IntegerClip.new( 0, 127, 0 ), // special tascam meter
	ringTascam: IntegerClip.new( 0, 127, 0 ), // special tascam meter
	midiLedTri: IntegerClip.new( 0, 2, 0 ), // tristate led
	// midiLedTri: [0, 2, \linear, 1, 0 ].asSpec, // tristate led
),


// hardwarePages: [1, 2, 3, 4],

deviceInfo: (
	vendorURI: 'http://tascam.com/product/us-2400/',
	manualURI: 'http://tascam.com/product/us-2400/downloads/',
	// description: ,
	features: [
		"25 motor-faders with touch",
		"24 rotary-encoders",
		"97 Buttons with 3-state leds",
		"jogwheel",
		"joystick"
	],
	notes: "meter button only sends a 127 value: it also has a side effect for the encoder led indicators to be used as meter outputs",
	// hasScribble: false
),

elementsDesc: (
	elements: [
		( // three sections with sliders, buttons and encoder
			key: \sec,
			elements: 3.collect{ |sec|
				(
					key: sec,
					elements: [
						(	// encoder - row 0 // relative input!
							key: \enc,
							shared: (elementType: \encoder, mode: \relative, spec: \relativeTascam, ioType: \in, midiMsgType: \cc, midiChan: 0),
							elements: (0..7).collect{ |cc|
								(
									key: cc,
									midiNum: 64+cc+(sec*8), \style: ( row: 0, column: cc+(sec*8) ),
									label: ("e"++(1+cc+(sec*8))),
								)
							};
						),
						(	// meter
							key: \mtr,
							shared: (elementType: \meter, spec: \meterTascam, ioType: \out, midiMsgType: \cc, midiChan: 0), // meter
							elements: (0..7).collect{ |cc|
								(
									key: cc,
									midiNum: 96+cc+(sec*8), \style: ( row: 10, column: cc+(sec*8), height: 2, width:0.6 ),
								)
							};
						),
						(	// encoder rings
							key: \ring,
							shared: (elementType: \meter, spec: \ringTascam, ioType: \out, midiMsgType: \cc, midiChan: 0), // encoder ring
							elements: (0..7).collect{ |cc|
								(
									key: cc,
									midiNum: 64+cc+(sec*8), \style: ( row: 10, column: cc+(sec*8)+0.5, height: 2, width:0.6 ),
								)
							};
						),
						(
							key: \bt,
							shared: ( midiMsgType: \cc, midiChan: 1, elementType: \button, mode: \push, spec: \midiBut, ioType: \in ),
							elements: [ \sel, \solo, \mute ].collect{ |ky, j|
								(
									key: ky,
									elements: 8.collect{ |i|
										(
											key: i,
											midiNum: ( j+1 + (i+(sec*8)*4)), // 1,2,3 5,6,7 // 33,34,35 // 65,66,67
											// ( var j=2, i=0, sec=2; (j+1 + (i+(sec*8)*4)).postln)
											style: ( row: 1+j, column: i+(sec*8), height: 0.75 ),
											label: (ky.asString.keep(2)++(1+i+(sec*8)))
										);
									}
								);
							};
						),
						(
							key: \led,
							// buttons [ sel, solo, mute ] - row 1,2,3
							shared: ( midiMsgType: \cc, midiChan: 1, elementType: \led, spec: \midiLedTri, ioType: \out ),
							elements: [ \sel, \solo, \mute ].collect{ |ky, j|
								(
									key: ky,
									elements: 8.collect{ |i|
										(
											key: i,
											midiNum: ( j+1 + (i+(sec*8)*4)),
											style: ( row: 1+j+0.5, column: i+(sec*8), height: 0.75 ),
											label: (ky.asString.keep(2)++(1+i+(sec*8)))
										);
									}
								);
							};
						),
						(
							key: \sl,
							shared: (elementType: \slider, spec: \faderTascam, ioType: \inout, midiMsgType: \cc14, midiChan: 0),
							elements: (0..7).collect{ |cc|
								(
									key: cc,
									midiNum: cc+(sec*8), \style: ( row: 4, column: cc+(sec*8), height: 5 ),
									label: ("sl"++(1+cc+(sec*8))),
								)
							};
						),
						(
							key: \tch,
							shared: (elementType: \button, mode: \push, spec: \midiBut, ioType: \in, midiMsgType: \cc, midiChan: 1), //elementType: \chanTouch
							elements: (0..7).collect{ |cc|
								(
									key: cc,
									midiNum: (cc+(sec*8)*4),
									label: ("t"++(1+cc+(sec*8))),
									style: ( row: 9, column: cc+(sec*8) )
								)
							};
						);
					];
				);
			};
		),
		( // master
			key: \mst,
			elements: [
				(
					key: \bt,
					shared: ( elementType: \button, mode: \push, spec: \midiBut, ioType: \in, midiMsgType: \cc, midiChan: 1 ),
					elements: [
						(
							key: \sel,
							midiNum: 97,
							label: \sel,
							style: ( row: 1, column: 24, height: 0.75 )
						),
						(
							key: \clr,
							midiNum: 98,
							label: \clr,
							style: ( row: 2, column: 24, height: 0.75 )
						),
						(
							key: \flip,
							midiNum: 99,
							label: \flip,
							style: ( row: 3, column: 24, height: 0.75 )
						)
					]
				),
				(
					key: \led,
					shared: ( elementType: \led, spec: \midiLedTri, ioType: \out, midiMsgType: \cc, midiChan: 1 ),
					elements: [
						(
							key: \sel,
							midiNum: 97,
							label: \sel,
							style: ( row: 1.5, column: 24, heigth: 0.5 )
						),
						(
							key: \clr,
							midiNum: 98,
							label: \clr,
							style: ( row: 2.5, column: 24, heigth: 0.5 )
						),
						(
							key: \flip,
							midiNum: 99,
							label: \flip,
							style: ( row: 3.5, column: 24, heigth: 0.5 )
						)
					]
				),
				(
					key: \sl,
					elementType: \slider, spec: \faderTascam, ioType: \inout, midiMsgType: \cc14, midiChan: 0,
					midiNum: 24,
					label: \msl,
					\style: ( row: 4, column: 24, height: 5 )
				),
				(
					key: \tch,
					elementType: \button, mode: \push, spec: \midiBut, ioType: \in, midiMsgType: \cc, midiChan: 2, // elementType: \chanTouch
					midiNum: 0,
					label: \mtch,
					\style: ( row: 9, column: 24 )
				)
			]
		),
		(
			key: \ctl,
			shared: ( midiMsgType: \cc ),
			elements: [
				(
					key: \jog,
					midiNum: 60, midiChan: 0,
					mode: \relative,
					ioType: \in, elementType: \jogWheel, spec: \relativeTascam, // relative!!
					style: ( row: 4, column: 26, width: 2, height: 2 )
				),
				(
					key: \joy,
					shared: ( ioType: \in, elementType: \joyAxis, spec: \midiCC, midiChan: 14 ),
					elements: [ \x,\y ].collect{ |ky,i|
						(
							key: ky, midiNum: 90+i,
							style: ( row: 4, column: 28+i, width: 1, height: 2 )
						)
					};
				),
				(
					key: \bt,
					shared:  ( elementType: \button, mode: \push, spec: \midiBut, midiChan: 1, ioType: \in ),
					elements:
					[ \rew, \fwd, \stop, \play, \rec ].collect{ |ky,i|
						(
							key: ky, midiNum: 117 + i,
							label: ky, style: ( row: 8, column: 25+i, height: 0.75 )
						)
					} ++
					[ \bmin, \bpl, \in, \out, \shift ].collect{ |ky,i|
						(
							key: ky, midiNum: 112 + i,
							label: ky, style: ( row: 7, column: 25+i, height: 0.75 )
						)
					} ++
					[
						(
							key: \scrub, midiNum: 111,
							label: \scrub, style: ( row: 6, column: 25, height: 0.75 )
						),
						(
							key: \null, midiNum: 110,
							label: \null, style: ( row: 3, column: 28, height: 0.75 )
						),
						(
							key: \pan, midiNum: 108,
							label: \pan, style: ( row: 2, column: 25, height: 0.75 )
						)
					] ++
					[ \aux4, \aux5, \aux6 ].collect{ |ky,i|
						(
							key: ky, midiNum: 104+i,
							label: ky, style: ( row: 2, column: 26+i, height: 0.75 )
						)
					} ++ [
						(
							key: \fkey, midiNum: 109,
							label: \fkey, style: ( row: 2, column: 29, height: 0.75 )
						)
					] ++
					[ \chan, \aux1, \aux2, \aux3 ].collect{ |ky,i|
						(
							key: ky, midiNum: 100+i,
							label: ky,
							style: ( row: 1, column: 25+i, height: 0.75 )
						)
					} ++
					[
						(
							// FIXME: meter button only sends a 127 value: so we need a trigger type
							// it also has a side effect for the encoder led indicators to be used as meter outputs
							key: \mtr, midiNum: 107, mode: \trig,
							label: \mtr, style: ( row: 1, column: 29, height: 0.75 )
						)
					]
				),
				(
					key: \led,
					shared:  ( elementType: \led, spec: \midiLedTri, midiChan: 1, \ioType: \out ),
					elements:
					[ \rew, \fwd, \stop, \play, \rec ].collect{ |ky,i|
						(
							key: ky, midiNum: 117 + i,
							label: ky, style: ( row: 8.5, column: 25+i, height: 0.75 )
						)
					} ++
					[ \bmin, \bpl, \in, \out, \shift ].collect{ |ky,i|
						(
							key: ky, midiNum: 112 + i,
							label: ky, style: ( row: 7.5, column: 25+i, height: 0.75 )
						)
					} ++
					[
						(
							key: \scrub, midiNum: 111,
							label: \scrub, style: ( row: 6.5, column: 25, height: 0.75 )
						),
						(
							key: \null, midiNum: 110,
							label: \null, style: ( row: 3.5, column: 28, height: 0.75 )
						),
						(
							key: \pan, midiNum: 108,
							label: \pan, style: ( row: 2.5, column: 25, height: 0.75 )
						)
					] ++
					[ \aux4, \aux5, \aux6 ].collect{ |ky,i|
						(
							key: ky, midiNum: 104+i,
							label: ky, style: ( row: 2.5, column: 26+i, height: 0.75 )
						)
					} ++ [
						(
							key: \fkey, midiNum: 109,
							label: \fkey, style: ( row: 2.5, column: 29, height: 0.75 )
						)
					] ++
					[ \chan, \aux1, \aux2, \aux3 ].collect{ |ky,i|
						(
							key: ky, midiNum: 100+i,
							label: ky,
							style: ( row: 1.5, column: 25+i, height: 0.75 )
						)
					} ++
					[
						(
							key: \mtr, midiNum: 107, mode: \trig,
							label: \mtr, style: ( row: 1.5, column: 29, height: 0.75 )
						)
					]
				),
				(
					key: \ft,
					shared: ( ioType: \in, elementType: \pedal, spec: \midiCC, midiChan: 0),
					elements: [
						(
							midiNum: 92,
							style: ( row: 9, column: 25, width: 2 )
						),
						(
							midiNum: 93,
							style: ( row: 9, column: 27, width: 2 )
						)
					]
				)
			]
		)
	];
)

);
