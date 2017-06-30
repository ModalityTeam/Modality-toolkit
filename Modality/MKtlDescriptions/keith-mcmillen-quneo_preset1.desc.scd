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
    shared: ( midiChan: 0, elementType: \pad ),
    elements:

    // independant buttons
    [
        [\play, 26, 86],
        [\stop, 25, 85],
        [\rec, 24, 84],
        [\rhombus, 19, 79]
    ]
    .collect { |midiSpec, index|
        (
            key: midiSpec[0],
            shared: ( ioType: \in ),
            elements: [
                ( key: \on, midiNum: midiSpec[1], midiMsgType: \noteOn, spec: \midiVel ),
                ( key: \off, midiNum: midiSpec[1], midiMsgType: \noteOff, spec: \midiVel ),
                ( key: \pressure, midiNum: midiSpec[2], midiMsgType: \control, spec: \midiCC )
            ]
        )
    }

    ++ // concat the above Array with the one that follows

    [
        (
            key: \arrow,
            shared: ( ioType: \in ),
            elements:
            [
                [ //left
                    [11, 71], //1
                    [13, 73], //2
                    [15, 75], //3
                    [17, 77], //4
                ],
                [ //right
                    [12, 72], //1
                    [14, 74], //2
                    [16, 76], //3
                    [18, 78], //4
                ],
                [ //up
                    [20, 80], //1
                    [22, 82], //2
                ],
                [ //down
                    [21, 81], //1
                    [23, 83], //2
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
                                ( key: \pressure, midiNum: midiSpec[1], midiMsgType: \control, spec: \midiCC )
                            ]
                        )
                    }
                )
            }
        ),
        (
            key: \slider,
            shared: ( ioType: \in ),
            elements: ([ (0..3)+++(12..15) ] ++ [ (6..9)+++(18..21) ]).collect { |sliders, index|
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
                                ( key: \location, midiNum: midiSpec[0], midiMsgType: \control, spec: \midiCC )
                            ]
                        )
                    }
                )
            }
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
            elements: ([4, 5] +++ [16, 17]).collect { |midiSpec, index|
                (
                    key: (index+1).asSymbol,
                    elements: [
                        ( key: \on, midiNum: midiSpec[0], midiMsgType: \noteOn, spec: \midiVel ),
                        ( key: \off, midiNum: midiSpec[0], midiMsgType: \noteOff, spec: \midiVel ),
                        ( key: \pressure, midiNum: midiSpec[1], midiMsgType: \control, spec: \midiCC ),
                        ( key: \location, midiNum: midiSpec[0], midiMsgType: \control, spec: \midiCC )
                    ]
                )
            }
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
            // LEDs
            key: \led,
            shared: ( ioType: \out ),
            elements: [
                ( key: \rec, midiNum: 9, groupType: \noteOnOff, spec: \midiVel ),
                ( key: \stop, midiNum: 10, groupType: \noteOnOff, spec: \midiVel ),
                ( key: \play, midiNum: 11, groupType: \noteOnOff, spec: \midiVel ),
                (
                    key: \slider,
                    elements: [ (1..4), (8..11) ].collect { |sliders, index|
                        var orientation = [\horizontal, \vertical].at(index);
                        (
                            key: orientation,
                            elements: sliders.collect { |midiSpec, index|
                                ( key: (index+1).asSymbol, midiNum: midiSpec, midiMsgType: \control, spec: \midiCC )
                            }
                        )
                    }
                ),
                ( key: \long, midiNum: 5, midiMsgType: \control, spec: \midiCC ),
                (
                    key: \rotary,
                    elements: [6, 7].collect { |midiNum, index|
                        ( key: (index+1).asSymbol, midiNum: midiNum, midiMsgType: \control, spec: \midiCC )
                    }
                ),
                (
                    key: \arrow,
                    elements: [ [12, 14, 16, 18], [13, 15, 17, 19], [22, 24], [23, 25] ].collect { |arrows, index|
                        var orientation = [\left, \right, \up, \down].at(index);
                        (
                            key: orientation,
                            elements: arrows.collect { |midiSpec, index|
                                ( key: (index+1).asSymbol, midiNum: midiSpec, groupType: \noteOnOff, spec: \midiVel )
                            }
                        )
                    }
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
        )
    ]
)
)
