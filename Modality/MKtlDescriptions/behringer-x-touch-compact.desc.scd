/****

2 layers
touch
motorized control

foot pedal and expression pedal are not implemented yet

****/
// a =
(
deviceName: "X-TOUCH COMPACT",
protocol: 'midi',
deviceType: 'mixer',
elementTypes: [ \encoder, \fader, \button ],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "X-TOUCH COMPACT",

hardwarePages: [1, 2],

// deviceInfo: (
// vendorURI: 'http://company.com/products/this',
// manualURI: 'http://company.com/products/this/manual.pdf',
	// description: ,
	// features: [],
	// notes: ,
	// hasScribble: false
// ),

elementsDesc: (
	key: \lyr,
	shared: ( midiChan: 0, ioType: \in ), //, \ioType: \inout ),
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
										midiNum: i + [ 40, 95 ].at(lyr)
									)
								),
								(
									midiMsgType: \cc, spec: \midiCC,
									key: \sl,
									elementType: \slider,
									midiNum: i + [ 1, 28 ].at(lyr)
								),
								(
									midiMsgType: \cc, spec: \midiCC,
									key: \tch,
									elementType: \touch,
									midiNum: i + [ 101, 111 ].at(lyr)
								),
								(
									midiMsgType: \cc, spec: \midiCC,
									key: \enc,
									elementType: \encoder,
									midiNum: i + [ 10, 37 ].at(lyr)
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
												midiNum: [16,71].at(lyr) + (jt*8) + i // 71,79,87
											)
										)
									}
								),
							]
						)
					}
				),
				(
					key: \enc,
					shared: ( midiMsgType: \cc, spec: \midiCC, elementType: \encoder ),
					elements: 8.collect{ |it|
						(
							key: it+9,
							midiNum: [18,45].at(lyr)+it // 45
						)
					};
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
								midiNum: [48,103].at(lyr)
							)
						),
						(
							midiMsgType: \cc, spec: \midiCC,
							key: \sl,
							elementType: \slider,
							midiNum: [9, 36].at(lyr)
						),
						(
							midiMsgType: \cc, spec: \midiCC,
							key: \tch,
							elementType: \touch,
							midiNum: [109, 119].at(lyr)
						)
					]
				),
				(
					// transport controls
					key: \tr,
					shared: ( groupType: \noteOnOff, spec: \midiBut, elementType: \button, mode: \push ),
					elements: [
						( key: \rew,
							shared: (
								label: \rew, midiNum: [49,104].at(lyr),
								style: ( row: 0, column: 0 )
							)
						),
						( key: \fwd,
							shared: (
								label: \fwd, midiNum: [50,105].at(lyr),
								style: ( row: 0, column: 1 )
							)
						),
						( key: \loop,
							shared: (
								label: \loop, midiNum: [51,106].at(lyr),
								style: ( row: 1, column: 0 )
							)
						),
						( key: \rec,
							shared: (
								label: \rec, midiNum:  [52, 107].at(lyr),
								style: ( row: 1, column: 1 )
							)
						),
						( key: \stop,
							shared: (
								label: \stop, midiNum: [53, 108].at(lyr),
								style: ( row: 2, column: 0 )
							)
						),
						( key: \play,
							shared: (
								label: \play, midiNum: [54, 109].at(lyr),
								style: ( row: 2, column: 1 )
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