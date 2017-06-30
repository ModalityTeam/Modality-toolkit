// A MKtl description for the QuNeo controller
// factory preset #1 (the lower left drum pad)
(
deviceName: "QUNEO",
protocol: \midi,
deviceType: \launchpad,
status: (
    linux: "tested on 28/05/2017 by @patrickdupuis. GUI styles forthcoming.",
    osx: "unknown",
    win: "unknown"
),

idInfo: "QUNEO",

deviceInfo: (
    vendorURI: "https://www.keithmcmillen.com/products/quneo/",
    manualURI: "http://www.keithmcmillen.com/downloads#quneo",
    description: "3D multi-touch pad controller",
    longName: "Keith McMillen QuNeo"
),

elementsDesc: (
    shared: ( midiChan: 0, elementType: \pad ),
    elements: [
        (
            key: \play,
            shared: ( ioType: \in ),
            elements: [
                ( key: \on, midiNum: 26, midiMsgType: \noteOn, spec: \midiVel ),
                ( key: \off, midiNum: 26, midiMsgType: \noteOff, spec: \midiVel ),
                ( key: \pressure, midiNum: 86, midiMsgType: \control, spec: \midiCC )
            ]
        ),
        (
            key: \stop,
            shared: ( ioType: \in ),
            elements: [
                ( key: \on, midiNum: 25, midiMsgType: \noteOn, spec: \midiVel ),
                ( key: \off, midiNum: 25, midiMsgType: \noteOff, spec: \midiVel ),
                ( key: \pressure, midiNum: 85, midiMsgType: \control, spec: \midiCC )
            ]
        ),
        (
            key: \rec,
            shared: ( ioType: \in ),
            elements: [
                ( key: \on, midiNum: 24, midiMsgType: \noteOn, spec: \midiVel ),
                ( key: \off, midiNum: 24, midiMsgType: \noteOff, spec: \midiVel ),
                ( key: \pressure, midiNum: 84, midiMsgType: \control, spec: \midiCC )
            ]
        ),
        (
            key: \rhombus,
            shared: ( ioType: \in ),
            elements: [
                ( key: \on, midiNum: 19, midiMsgType: \noteOn, spec: \midiVel ),
                ( key: \off, midiNum: 19, midiMsgType: \noteOff, spec: \midiVel ),
                ( key: \pressure, midiNum: 79, midiMsgType: \control, spec: \midiCC )
            ]
        ),
        (
            key: \arrow,
            shared: ( ioType: \in ),
            elements: [
                (
                    key: \1,
                    elements: [
                        (
                            key: \left,
                            elements: [
                                ( key: \on, midiNum: 11, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 11, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 71, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                        (
                            key: \right,
                            elements: [
                                ( key: \on, midiNum: 12, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 12, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 72, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                        // this is a little funky
                        (
                            key: \up,
                            elements: [
                                ( key: \on, midiNum: 20, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 20, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 80, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                        (
                            key: \down,
                            elements: [
                                ( key: \on, midiNum: 21, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 21, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 81, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                    ]
                ),
                (
                    key: \2,
                    elements: [
                        (
                            key: \left,
                            elements: [
                                ( key: \on, midiNum: 13, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 13, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 73, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                        (
                            key: \right,
                            elements: [
                                ( key: \on, midiNum: 14, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 14, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 74, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                        // same funky-ness here
                        (
                            key: \up,
                            elements: [
                                ( key: \on, midiNum: 22, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 22, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 82, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                        (
                            key: \down,
                            elements: [
                                ( key: \on, midiNum: 23, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 23, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 83, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                    ]
                ),
                (
                    key: \3,
                    elements: [
                        (
                            key: \left,
                            elements: [
                                ( key: \on, midiNum: 15, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 15, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 75, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                        (
                            key: \right,
                            elements: [
                                ( key: \on, midiNum: 16, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 16, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 76, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                    ]
                ),
                (
                    key: \4,
                    elements: [
                        (
                            key: \left,
                            elements: [
                                ( key: \on, midiNum: 17, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 17, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 77, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                        (
                            key: \right,
                            elements: [
                                ( key: \on, midiNum: 18, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 18, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 78, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                    ]
                ),
            ]
        ),
        (
            // Sliders (horizontal and vertical)
            key: \slider,
            shared: ( ioType: \in ),
            elements: [
                (
                    key: \horizontal,
                    elements: [
                        (
                            key: \1,
                            elements: [
                                ( key: \on, midiNum: 0, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 0, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 12, midiMsgType: \control, spec: \midiCC ),
                                ( key: \location, midiNum: 0, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                        (
                            key: \2,
                            elements: [
                                ( key: \on, midiNum: 1, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 1, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 13, midiMsgType: \control, spec: \midiCC ),
                                ( key: \location, midiNum: 1, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                        (
                            key: \3,
                            elements: [
                                ( key: \on, midiNum: 2, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 2, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 14, midiMsgType: \control, spec: \midiCC ),
                                ( key: \location, midiNum: 2, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                        (
                            key: \4,
                            elements: [
                                ( key: \on, midiNum: 3, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 3, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 15, midiMsgType: \control, spec: \midiCC ),
                                ( key: \location, midiNum: 3, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                    ]
                ),
                (
                    key: \vertical,
                    elements: [
                        (
                            key: \1,
                            elements: [
                                ( key: \on, midiNum: 6, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 6, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 18, midiMsgType: \control, spec: \midiCC ),
                                ( key: \location, midiNum: 6, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                        (
                            key: \2,
                            elements: [
                                ( key: \on, midiNum: 7, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 7, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 19, midiMsgType: \control, spec: \midiCC ),
                                ( key: \location, midiNum: 7, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                        (
                            key: \3,
                            elements: [
                                ( key: \on, midiNum: 8, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 8, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 20, midiMsgType: \control, spec: \midiCC ),
                                ( key: \location, midiNum: 8, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                        (
                            key: \4,
                            elements: [
                                ( key: \on, midiNum: 9, midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: 9, midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: 21, midiMsgType: \control, spec: \midiCC ),
                                ( key: \location, midiNum: 9, midiMsgType: \control, spec: \midiCC )
                            ]
                        ),
                    ]
                ),
            ]
        ),
        (
            key: \longSlider,
            shared: ( ioType: \in ),
            elements: [
                ( key: \on, midiNum: 10, midiMsgType: \noteOn, spec: \midiVel ),
                ( key: \off, midiNum: 10, midiMsgType: \noteOff, spec: \midiVel ),
                ( key: \pressure, midiNum: 22, midiMsgType: \control, spec: \midiCC ),
                ( key: \location, midiNum: 10, midiMsgType: \control, spec: \midiCC ),
                ( key: \width, midiNum: 11, midiMsgType: \control, spec: \midiCC )
            ]
        ),
        (
            key: \rotary,
            shared: ( ioType: \in ),
            elements: [
                (
                    key: \1,
                    elements: [
                        ( key: \on, midiNum: 4, midiMsgType: \noteOn, spec: \midiVel ),
                        ( key: \off, midiNum: 4, midiMsgType: \noteOff, spec: \midiVel ),
                        ( key: \pressure, midiNum: 16, midiMsgType: \control, spec: \midiCC ),
                        ( key: \location, midiNum: 4, midiMsgType: \control, spec: \midiCC )
                    ]
                ),
                (
                    key: \2,
                    elements: [
                        ( key: \on, midiNum: 5, midiMsgType: \noteOn, spec: \midiVel ),
                        ( key: \off, midiNum: 5, midiMsgType: \noteOff, spec: \midiVel ),
                        ( key: \pressure, midiNum: 17, midiMsgType: \control, spec: \midiCC ),
                        ( key: \location, midiNum: 5, midiMsgType: \control, spec: \midiCC )
                    ]
                ),
            ]
        ),
        (
            key: \pad,
            shared: ( ioType: \in ),
            elements: ((36..51) +++ (23..70).clump(3)).collect { | midiNum, index |
                (
                    key: (index+1).asSymbol,
                    elements: [
                        ( key: \on, midiNum: midiNum[0], midiMsgType: \noteOn, spec: \midiVel ),
                        ( key: \off, midiNum: midiNum[0], midiMsgType: \noteOff, spec: \midiVel ),
                        ( key: \pressure, midiNum: midiNum[1], midiMsgType: \control, spec: \midiCC ),
                        ( key: \x, midiNum: midiNum[2], midiMsgType: \control, spec: \midiCC ),
                        ( key: \y, midiNum: midiNum[3], midiMsgType: \control, spec: \midiCC )
                    ]
                )
            }
        ),
		(
			// LED output
			key: \led,
			shared: ( ioType: \out ),
			elements: [
                ( key: \rec, midiNum: 9, groupType: \noteOnOff, spec: \midiVel ),
                ( key: \stop, midiNum: 10, groupType: \noteOnOff, spec: \midiVel ),
                ( key: \play, midiNum: 11, groupType: \noteOnOff, spec: \midiVel ),
				(
					key: \slider,
					elements: [
						(
							key: \horizontal,
							elements: (1..4).collect { |ccNum, index|
								( key: (index+1).asSymbol, midiNum: ccNum, midiMsgType: \control, spec: \midiCC )
							}
						),
						(
							key: \vertical,
							elements: (8..11).collect { |ccNum, index|
								( key: (index+1).asSymbol, midiNum: ccNum, midiMsgType: \control, spec: \midiCC )
							}
						),
						( key: \long, midiNum: 5, midiMsgType: \control, spec: \midiCC )
					]
				),
				(
					key: \rotary,
					elements: [6, 7].collect { |midiNum, index|
						( key: (index+1).asSymbol, midiNum: midiNum, midiMsgType: \control, spec: \midiCC )
					}
				),
                (
					key: \arrow,
					elements: [
						(
							key: \1,
							elements: [12, 13, 22, 23].collect { |midiNum, index|
								var orientation = [\left, \right, \up, \down].at(index);
								( key: orientation, midiNum: midiNum, groupType: \noteOnOff, spec: \midiVel )
							}
						),
						(
							key: \2,
							elements: [14, 15, 24, 25].collect { |midiNum, index|
								var orientation = [\left, \right, \up, \down].at(index);
								( key: orientation, midiNum: midiNum, groupType: \noteOnOff, spec: \midiVel )
							}
						),
						(
							key: \3,
							elements: [16, 17].collect { |midiNum, index|
								var orientation = [\left, \right].at(index);
								( key: orientation, midiNum: midiNum, groupType: \noteOnOff, spec: \midiVel )
							}
						),
						(
							key: \4,
							elements: [18, 19].collect { |midiNum, index|
								var orientation = [\left, \right].at(index);
								( key: orientation, midiNum: midiNum, groupType: \noteOnOff, spec: \midiVel )
							}
						)
					]
				),
				(
					key: \rhombus,
					elements: [20, 21].collect { |midiNum, index|
							var color = [\red, \green].at(index);
							( key: color, midiNum: midiNum, groupType: \noteOnOff, spec: \midiVel )
					}
				),
				(
					key: \pad,
					elements: (0..31).clump(2).collect { |pads, index|
						(
							key: (index+1).asSymbol,
							elements: pads.collect { |midiNum, index|
								var color = [\green, \red].at(index);
								( key: color, midiNum: midiNum, groupType: \noteOnOff, spec: \midiVel )
							}
						)
					}
				)
			]
		) // end of LEDs
	]
),
)
