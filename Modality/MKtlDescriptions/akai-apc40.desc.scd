(
deviceName: "Akai APC40",
protocol: \midi,
deviceType: 'multiController',
elementTypes: [ \fader, \knob, \button ],
status: (
	linux: "tested and working",
	osx: "unknown",
	win: "tested and working"),

idInfo: "Akai APC40",

deviceInfo: (
	vendorURI: 'http://akaipro.com/product/apc40',
	manualURI: 'http://6be54c364949b623a3c0-4409a68c214f3a9eeca8d0265e9266c0.r0.cf2.rackcdn.com/754/documents/apc40___quickstart_guide___revd_1_.pdf',
	// description: ,
	// features: [],
	notes: "mapped using the 'mode 0'. TO DO: LEDs feedback in the Clip Launch http://6be54c364949b623a3c0-4409a68c214f3a9eeca8d0265e9266c0.r0.cf2.rackcdn.com/754/documents/APC40_Communications_Protocol_rev_1.pdf",
),



elementsDesc: (
	elements: [

		/////////////// BUTTONS //////////////////////////
		(
			key: \bt,
			shared: ( elementType:\button, spec:\midiVel, \ioType: \inout ),
			elements:
			[

				//---------- Clip Launch
				(
					key:\clip,
					elements: (53..57).collect{ |num, i| (
						elements: (0..7).collect{ |chan, j|
							MKtlDesc.notePair( (j+1).asSymbol, num,
								shared:( midiNum:num, midiChan:chan,
									buttonMode:\toggle, style:(row:i, column:j) ) )
						}
					) }
				),

				//---------- Clip Stop
				(
					key: \clipS,
					elements: (0..7).collect({ |chan, i|
						MKtlDesc.notePair( (i+1).asSymbol, midiNum:52,
							shared: (\midiChan:chan, style:(row:5.5, column:i) )
						)
					})
				),
				//--------- Stop All Clips
				(
					MKtlDesc.notePair( key:\stopAll, midiNum:81,
						shared:( midiChan: 0, style:(row:5.5, column:8) )
				)),

				//--------- Activator, Solo/Cue, Record Arm
				(
					elements: [50, 49, 48].collect{ |num, i| (
						elements: (0..7).collect{ |chan, j| (
							MKtlDesc.notePair(
								( ['activ', 'solo', 'rec'][i]++(1+j) ).asSymbol,
								midiNum:num,
								shared: ( midiChan:chan, /*buttonMode:\toggle, */
									style:( row:7+i, column:j, height:0.85 ) )
							)
						) }
					) }
				),
				//--------- Scene Launch
				(
					key: \scene,
					elements: (82..86).collect{ |num, i|
						MKtlDesc.notePair( key:((1+i).asSymbol), midiNum:num,
							shared: ( midiChan:0, style:( row: i, column:8 ) ) )
					}
				),
				// ******** Track Control - pan, send A, send B, send C
				(
					elements:  [87, 88, 89, 90].collect{ |num, i|
						MKtlDesc.notePair(
							key:[ 'pan', 'sendA', 'sendB', 'sendC' ][i],
							midiNum:num,
							shared:( midiChan:0, buttonMode:\toggle,
								style:( row:1.85, column:12+i, height:0.75 ) ) )
				} ),

				//------------ Shift ---------------- //
				(
					MKtlDesc.notePair( key:\shift, midiNum:98,
						shared:( midiChan: 0, elementType:\button, spec:\midiVel,
							style:( row:3, column:11.25, width:0.75, height:0.75 )
					) )
				),

				// ---------- Bank Select ----------- //
				(
					elements:[ 94, 97, 96, 95 ].collect{ |num, i|
						MKtlDesc.notePair( key:[ 'up', 'left', 'right', 'down' ][i],
							midiNum:num,
							shared:( midiChan:0,
								style:( row: 2.75+[0,0.3,0.3,0.75][i],
									column:12.25+[0.7,0,1.4,0.7][i],
									width:0.75, height:0.85 ) )
						)
				} ),

				//--------- Tap-Tempo, Nudge -, Nudge +
				(
					elements:  [ 99, 101, 100 ].collect{ |num, i|
						MKtlDesc.notePair( key:[ 'tap', 'minus', 'plus' ][i], midiNum:num,
							shared:( midiChan:0,
								style:( row:2.75+[ 0, 0.4, 0.4 ][i],
									column:14.75 + [ 0.7, 0, 1.4 ][i],
									width:0.75, height:[ 0.75, 0.75, 0.75 ][i] )
							)
						)
					}
				),

				// ******** Device Control ** - clip/track, device on/off, <-, ->
				(
					elements: (0..8).collect{ |chan, i| (
						elements: (58..61).collect( { |num, j|
							MKtlDesc.notePair(
								key:[ 'clitra', 'onoff', 'left', 'right' ][j],
								midiNum:num,
								shared:( midiChan:chan, buttonMode:\toggle,
									style:( row:4.5+i, column:18+j, height:0.75 )
								)
							)
						} )
					)
				} ),

				// detail view, rec/quantization, midi overdub, metronome
				(
					elements: (62..65).collect{ |num, i|
						MKtlDesc.notePair(
							key:['view', 'r_quant', 'ovDub', 'metron'][i],
							midiNum: num,
							shared:( midiChan:0, buttonMode:\toggle,
								style:( row:13.5 , column:12+i, height:0.75 )
							)
						)
					}
				),

				// transport buttons
				(
					elements:( [91, 92, 93].collect{ |num, i|
						MKtlDesc.notePair( key:[ 'play', 'stop', 'rec' ][i],
							midiNum:num,
							shared:( midiChan:0, style:( row:14.4,
								column:12.4+( i*1.16 ), width:0.85, height:0.75 ) )
						)
				})),

			]
		),


		//////////////////// SLIDERS /////////////////
		(
			key: \sl,
			shared: ( midiMsgType:\cc, elementType:\slider, spec:\midiCC ),
			elements:
			[
				(
					elements: (0..7).collect { |chan, i|
						(key: (i+1).asSymbol, midiChan:chan, midiNum:7,
							style:( row: 13.3, column: i )
						)
				}),

				( key:\master, midiNum:14, midiChan:0, spec:\midiCC,
					style:( row:13.3, column:8 ) )

			]
		),


		/////////////////// KNOBS ///////////////////////
		( key: \kn,
			shared:( midiMsgType:\cc, elementType:\knob, spec:\midiCC ),
			elements:
			[

				//-------------- cue level
				(
					key: \cue, midiNum:47, midiChan:0, midiMsgType:\cc,
					elementType:\knob, spec: \midiCC, valueType: \relative,
					style: ( row:9, column:8 )
				),

				//************** Track Control
				(
					key: \t,
					elements: (48..55).clump(4).collect{ |row, i|
						( elements:
							row.collect{ |num, j|
								( key:((1..8)[j]).asSymbol, midiChan:0, midiNum:num,
									style:( row:i, column:12+j ) )
							}
						)
					}
				),

				//************** Device Control (all channels)
				(
					key: \d,
					elements: (0..8).collect{ |chan, i| (
						elements: (16..23).collect { |num, j|
							( key: (1..8)[j].asSymbol,
								midiChan:chan, midiNum:num,
								style:( row:4.5+i, column:10+j )
							)
					} )
				} ),
			]
		),

		//--------------------- crossfader
		( key: \xfader,
			midiNum:15, midiChan:0, midiMsgType:\cc, elementType: \xfader,
			spec:\midiCC, style:( row:15.3, column:12, height: 1, width: 4 )
		)


	],
),
specialMessages: (
	makeButtonLEDsWriteable: [
		[ \sysex, Int8Array[ 0xF0, 0x7E, 0x00, 0x06, 0x01, 0xF7 ] ],
		[ \sysex, Int8Array[ 0xF0, 0x47, 0x00, 0x73, 0x60, 0x00, 0x04, 0x41, 0x08, 0x01, 0x01, 0xF7 ] ],
	]
);
)