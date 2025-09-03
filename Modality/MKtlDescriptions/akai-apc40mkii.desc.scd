(
deviceName: "APC40 mkII",
protocol: \midi,
deviceType: 'multiController',
elementTypes: [ \fader, \knob, \button ],
status: (
	linux: "tested and working",
	osx: "unknown",
	win: "unknown"),

idInfo: "APC40 mkII",

deviceInfo: (
	vendorURI: 'https://www.akaipro.com/apc40-mkii.html',
	manualURI: 'https://www.akaipro.com/downloads#apc40mkii',
	// description: ,
	// features: [],
	notes: "adapted from APC40 desc file",
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
					elements: (0..4).reverse.collect{ |row, i| (
						elements: (0..7).collect{ |col, j|
							MKtlDesc.notePair( (j+1).asSymbol, col+(row*8),
								shared:( midiNum:col+(row*8), midiChan:0,
									buttonMode:\toggle, style:(row:i, column:j) ) )
						}
					) }
				),
				//---------- Clip color
				(
					key:\clipColor,
					elements: (0..4).reverse.collect{ |row, i| (
						elements: (0..7).collect{ |col, j|
							(
								elements: [0,13].collect { arg colormode, idx;
									( 
										key: [\normal, \blink][idx],
										midiNum:col+(row*8), 
										midiMsgType: \noteOn,
										midiChan:colormode,
										buttonMode:\toggle, 
										ioType: \out,
									)
									
								};
							)
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

				//---------- Clip select
				(
					key: \selection,
					elements: (0..7).collect({ |chan, i|
						MKtlDesc.notePair( (i+1).asSymbol, midiNum:51,
							shared: (\midiChan:chan, style:(row:5.5, column:i) )
						)
					})
				),
				//--------- Master
				(
					MKtlDesc.notePair( key:\master, midiNum:80,
						shared:( midiChan: 0, style:(row:5.5, column:8) )
				)),


				//--------- Activator, Solo/Cue, Record Arm
				(
					key: \track,
					elements: [50, 49, 48, 66].collect{ |num, i| (
						key:( ['activ', 'solo', 'rec', 'ab'][i] ).asSymbol,
						elements: (0..7).collect{ |chan, j| (
							MKtlDesc.notePair(
								( ['activ', 'solo', 'rec', 'ab'][i]++(1+j) ).asSymbol,
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
				// ******** Track Control - pan, sends, user
				(
					key: \control,
					elements:  [87, 88, 89].collect{ |num, i|
						MKtlDesc.notePair(
							key:[ 'pan', 'sends', 'user'][i],
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

				//------------ Bank toggle ---------------- //
				(
					MKtlDesc.notePair( key:\bank, midiNum:103,
						shared:( midiChan: 0, elementType:\button, spec:\midiVel,
							style:( row:3, column:11.25, width:0.75, height:0.75 )
					) )
				),

				// ---------- Bank Select ----------- //
				(
					key:\bankselect,
					elements:[ 94, 97, 96, 95 ].collect{ |num, i|
						MKtlDesc.notePair( key:[ 'up', 'left', 'right', 'down' ][i],
							midiNum:num,
							shared:( midiChan:0,
								style:( row: 2.75+[0,0.3,0.3,0.75][i],
									column:12.25+[0.7,0,1.4,0.7][i],
									width:0.75, height:0.85 ) )
						)
				} ),

				//--------- Metronome, Tap-Tempo, Nudge -, Nudge +
				(
					key:\tempo,
					elements:  [ 90, 99, 101, 100 ].collect{ |num, i|
						MKtlDesc.notePair( key:[ 'metronome', 'tap', 'minus', 'plus' ][i], midiNum:num,
							shared:( midiChan:0,
								style:( row:2.75+[ 0, 0.4, 0.4, 0.4 ][i],
									column:14.75 + [ 0.7, 0, 1.4, 1.4 ][i],
									width:0.75, height:[ 0.75, 0.75, 0.75, 0.75 ][i] )
							)
						)
					}
				),

				// ******** Device Control ** 
				// dev<-, dev->, bank<-, bank->, device on/off, dev lock, clipdev view, detail view
				(
					key:\device,
					elements: (0..8).collect{ |chan, i| (
						elements: (58..65).collect( { |num, j|
							MKtlDesc.notePair(
								key:[ 
									'devleft', 'devright', 'bankleft', 'bankright', 
									'devonoff', 'devlock', 'clipdev', 'detail'
							   	][j],
								midiNum:num,
								shared:( midiChan:chan, buttonMode:\toggle,
									style:( row:4.5+i, column:18+j, height:0.75 )
								)
							)
						} )
					)
				} ),


				// transport buttons
				(
					key: \transport,
					elements:( [91, 93, 102].collect{ |num, i|
						MKtlDesc.notePair( key:[ 'play', 'rec', 'session' ][i],
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

				//-------------- tempo
				(
					key: \tempo, midiNum:13, midiChan:0, midiMsgType:\cc,
					elementType:\knob, spec: \midiCC, valueType: \relative,
					style: ( row:9, column:8 )
				),

				//-------------- cue level
				(
					key: \cue, midiNum:47, midiChan:0, midiMsgType:\cc,
					elementType:\knob, spec: \midiCC, valueType: \relative,
					style: ( row:9, column:8 )
				),

				//************** Track Control
				(
					key: \t,
					elements: (48..55).collect{ |num, i|
						( 
							key:(i+1).asSymbol, 
							midiChan:0, 
							midiNum:num,
							ioType: \inout,
							style:( row:i  ) 
						)
					}
				),

				//************** Device Control (all channels)
				(
					key: \d,
					elements: (0..8).collect{ |chan, i| 
						(
							elements: (16..23).collect { |num, j|
								( 
									key: (1..8)[j].asSymbol,
									ioType: \inout,
									midiChan:chan, 
									midiNum:num,
									style:( row:4.5+i, column:10+j )
								)
							} 
						)
					} 
				),
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
	],
	abletonLiveMode: [
		[ \sysex, Int8Array[ 0xF0, 0x47, 0x00, 0x29, 0x60, 0x00, 0x04, 0x41, 0x08, 0x01, 0x01, 0xF7 ] ],
	]
);
)
