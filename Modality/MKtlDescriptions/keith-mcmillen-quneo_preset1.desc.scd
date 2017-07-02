// A MKtl description for the QuNeo controller
// factory preset #1 (the lower left drum pad)
(
deviceName: "QUNEO",
protocol: \midi,
deviceType: \launchpad,
status: (
    linux: "tested on 28/05/2017 by @patrickdupuis. GUI not included.",
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
    shared: ( midiChan: 0, elementType: \pad, ioType: \in ),
    elements:

    // independant buttons
    [
        [\play, 26, 86, 35],
        [\stop, 25, 85, 34],
        [\rec, 24, 84, 33],
    ]
    .collect { |midiSpec, index|
        (
            key: midiSpec[0],
            elements: [
                ( key: \on, midiNum: midiSpec[1], midiMsgType: \noteOn, spec: \midiVel ),
                ( key: \off, midiNum: midiSpec[1], midiMsgType: \noteOff, spec: \midiVel ),
                ( key: \pressure, midiNum: midiSpec[2], midiMsgType: \control, spec: \midiCC ),
                ( key: \led, midiNum: midiSpec[3], midiMsgType: \noteOn, spec: \midiVel, ioType: \out, elementType: \led )
            ]
        )
    }

    ++

    [
	(
		key: \rhombus,
		elements: [
			( key: \on, midiNum: 19, midiMsgType: \noteOn, spec: \midiVel ),
			( key: \off, midiNum: 19, midiMsgType: \noteOff, spec: \midiVel ),
			( key: \pressure, midiNum: 79, midiMsgType: \control, spec: \midiCC ),
			(
				key: \led,
				shared: ( ioType: \out, elementType: \led, midiMsgType: \noteOn, spec: \midiVel ),
				elements: [
					( key: \red, midiNum: 44 ),
					( key: \green, midiNum: 45 )
				]
			)
		]
	),
        (
            key: \arrow,
            elements:
            [
                [ //left
                    [11, 71, 36], //1
                    [13, 73, 38], //2
                    [15, 75, 40], //3
                    [17, 77, 42], //4
                ],
                [ //right
                    [12, 72, 37], //1
                    [14, 74, 39], //2
                    [16, 76, 41], //3
                    [18, 78, 43], //4
                ],
                [ //up
                    [20, 80, 46], //1
                    [22, 82, 48], //2
                ],
                [ //down
                    [21, 81, 47], //1
                    [23, 83, 49], //2
                ],
            ].collect { |arrows, index|
                var orientation = [\left, \right, \up, \down].at(index);
                (
                    key: orientation,
                    elements: arrows.collect { |midiSpec, index|
                        (
                            key: (index+1).asSymbol,
                            elements: [
                                ( key: \on, midiNum: midiSpec[0], midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: midiSpec[0], midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: midiSpec[1], midiMsgType: \control, spec: \midiCC ),
                                ( key: \led, midiNum: midiSpec[2], midiMsgType: \noteOn, spec: \midiVel, ioType: \out, \elementType: \led )
                            ]
                        )
                    }
                )
            }
        ),
        (
            key: \slider,
            elements: ([ (0..3)+++(12..15)+++(1..4) ] ++ [ (6..9)+++(18..21)+++(8..11) ]).collect { |sliders, index|
                var orientation = [\horizontal, \vertical].at(index);
                (
                    key: orientation,
                    elements: sliders.collect { | midiSpec, index|
                        (
                            key: (index+1).asSymbol,
                            elements: [
                                ( key: \on, midiNum: midiSpec[0], midiMsgType: \noteOn, spec: \midiVel ),
                                ( key: \off, midiNum: midiSpec[0], midiMsgType: \noteOff, spec: \midiVel ),
                                ( key: \pressure, midiNum: midiSpec[1], midiMsgType: \control, spec: \midiCC ),
                                ( key: \location, midiNum: midiSpec[0], midiMsgType: \control, spec: \midiCC ),
                                ( key: \led, midiNum: midiSpec[2], midiMsgType: \control, spec: \midiCC, ioType: \out, elementType: \led )
                            ]
                        )
                    }
                )
            }
        ),
        (
            key: \longSlider,
            elements: [
                ( key: \on, midiNum: 10, midiMsgType: \noteOn, spec: \midiVel ),
                ( key: \off, midiNum: 10, midiMsgType: \noteOff, spec: \midiVel ),
                ( key: \pressure, midiNum: 22, midiMsgType: \control, spec: \midiCC ),
                ( key: \location, midiNum: 10, midiMsgType: \control, spec: \midiCC ),
                ( key: \width, midiNum: 11, midiMsgType: \control, spec: \midiCC ),
                ( key: \led, midiNum: 5, midiMsgType: \control, spec: \midiCC, ioType: \out, elementType: \led )
            ]
        ),
        (
            key: \rotary,
            elements: ([4, 5] +++ [16, 17] +++ [6, 7]).collect { |midiSpec, index|
                (
                    key: (index+1).asSymbol,
                    elements: [
                        ( key: \on, midiNum: midiSpec[0], midiMsgType: \noteOn, spec: \midiVel ),
                        ( key: \off, midiNum: midiSpec[0], midiMsgType: \noteOff, spec: \midiVel ),
                        ( key: \pressure, midiNum: midiSpec[1], midiMsgType: \control, spec: \midiCC ),
                        ( key: \location, midiNum: midiSpec[0], midiMsgType: \control, spec: \midiCC ),
                        ( key: \led, midiNum: midiSpec[2], midiMsgType: \control, spec: \midiCC, ioType: \out, elementType: \led )
                    ]
                )
            }
        ),
        (
            key: \pad,
            elements: ( (36..51) +++ (23..70).clump(3) +++ (0..31).clump(2) ).collect { | midiNum, index |
                (
                    key: (index+1).asSymbol,
                    elements: [
                        ( key: \on, midiNum: midiNum[0], midiMsgType: \noteOn, spec: \midiVel ),
                        ( key: \off, midiNum: midiNum[0], midiMsgType: \noteOff, spec: \midiVel ),
                        ( key: \pressure, midiNum: midiNum[1], midiMsgType: \control, spec: \midiCC ),
                        ( key: \x, midiNum: midiNum[2], midiMsgType: \control, spec: \midiCC ),
                        ( key: \y, midiNum: midiNum[3], midiMsgType: \control, spec: \midiCC ),
			(
				key: \led,
				shared: ( ioType: \out, elementType: \led, midiMsgType: \noteOn, spec: \midiVel ),
				elements: [
					( key: \green, midiNum: midiNum[4] ),
					( key: \red, midiNum: midiNum[5] )
				]
			)
                    ]
                )
            }
        )
    ]
)
)

