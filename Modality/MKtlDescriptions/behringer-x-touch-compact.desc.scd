/****

2 layers
touch
motorized control

foot pedal and expression pedal are not implemented yet
output to device is not implemented yet

****/
// a =
(
deviceName: "X-TOUCH COMPACT",
protocol: 'midi',
deviceType: 'mixer',
elementTypes: [ \encoder, \fader, \button ],
status: (
	linux: "tested and working, except for output and pedals; 24-05-2017 by nescivi",
	osx: "unknown",
	win: "unknown"),

idInfo: "X-TOUCH COMPACT",

hardwarePages: [1, 2],

deviceInfo: (
	vendorURI: "",
	manualURI: "",
	// description: "",
	features: [
		"9 touch sensitive motor-faders",
		"16 rotary-encoder",
		"36 Buttons"
	],
	// notes: "",
	longName: "Behringer X Touch Compact"
),

elementsDesc: (
	key: \lyr,
	shared: ( midiChan: 0, ioType: \inout ), //, \ioType: \inout ),
	elements: 2.collect{ |lyr|
		(
			shared: ( \page: lyr ),
			elements: [
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
										style: ( row: 9, column: i ),
										label: ("mc"++(i+1) )
									)
								),
								(
									midiMsgType: \cc, spec: \midiCC,
									key: \sl,
									elementType: \slider,
									midiNum: i + [ 1, 28 ].at(lyr),
									style: ( row: 5, column: i, height: 4 ),
									label: ("sl"++(i+1) )
								),
								(
									midiMsgType: \cc, spec: \midiCC,
									key: \tch,
									elementType: \touch,
									midiNum: i + [ 101, 111 ].at(lyr),
									label: ("enc"++(i+1) ),
									style: ( row: 4, column: i )
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
												style: ( row: 1+jt, column: i ),
												label: ("bt"++(i+1)++"_"++(jt+1))
											)
										)
									}
								),
								(
									midiMsgType: \cc, spec: \midiCC,
									key: \enc,
									elementType: \encoder,
									midiNum: i + [ 10, 37 ].at(lyr),
									style: ( row: 0, column: i ),
									label: ("enc"++(i+1) )
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
								style: ( row: 9, column: 8 )
							)
						),
						(
							midiMsgType: \cc, spec: \midiCC,
							key: \sl,
							elementType: \slider,
							midiNum: [9, 36].at(lyr),
							label: 'sl_main',
							style: ( row: 5, column: 8, height: 4 )
						),
						(
							midiMsgType: \cc, spec: \midiCC,
							key: \tch,
							elementType: \touch,
							midiNum: [109, 119].at(lyr),
							label: 'tch_main',
							style: ( row: 4, column: 8 )
						)
					]
				),
				(
					key: \enc,
					shared: ( midiMsgType: \cc, spec: \midiCC, elementType: \encoder ),
					elements: 8.collect{ |it|
						(
							key: it+9,
							midiNum: [18,45].at(lyr)+it, // 45
							style: ( row: (it/2).floor, column: 9 + (it%2) ),
							label: ("enc"++(it+9) )
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
								style: ( row: 6, column: 9 )
							)
						),
						( key: \fwd,
							shared: (
								label: \fwd, midiNum: [50,105].at(lyr),
								style: ( row: 6, column: 10 )
							)
						),
						( key: \loop,
							shared: (
								label: \loop, midiNum: [51,106].at(lyr),
								style: ( row: 7, column: 9 )
							)
						),
						( key: \rec,
							shared: (
								label: \rec, midiNum:  [52, 107].at(lyr),
								style: ( row: 7, column: 10 )
							)
						),
						( key: \stop,
							shared: (
								label: \stop, midiNum: [53, 108].at(lyr),
								style: ( row: 8, column: 9 )
							)
						),
						( key: \play,
							shared: (
								label: \play, midiNum: [54, 109].at(lyr),
								style: ( row: 8, column: 10 )
							)
						)
					]
				)
			]
		);
	};
);
);


/*
		( // master fader strip
			key: \master,
			elements: [
				(
					groupType: \noteOnOff,
					key: \mc,
					shared: (
						spec: \midiBut,
						elementType: \button,
						midiNum: 48 // 103
					)
				),
				(
					midiMsgType: \cc, spec: \midiCC,
					key: \sl,
					elementType: \slider,
					midiNum: 9 // 36
				),
				(
					midiMsgType: \cc, spec: \midiCC,
					key: \tch,
					elementType: \touch,
					midiNum: 109 // 119
				)
			]
		)
*/

		/*
		( // transport controls
			key: \tr,
			shared: ( midiMsgType: \cc, spec: \midiCC, elementType: \button ),
			elements: [
				( key: \rew, midiNum: 49 // 104
				),
				( key: \fwd, midiNum: 50 // 105
				),
				( key: \loop, midiNum: 51 // 106
				),
				( key: \rec, midiNum: 52 // 107
				),
				( key: \stop, midiNum: 53 // 108
				),
				( key: \play, midiNum: 54 // 109
				)
			]
		)
*/

	/*
	++
	8.collect{ |it| // encoders -- could also be a group
		(
			midiMsgType: \cc, spec: \midiCC,
			key: \enc,
			elementType: \encoder,
			midiNum: 18+it // 45
		)
	};
	*/
	// )