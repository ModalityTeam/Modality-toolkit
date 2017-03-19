// contributed by gil fuser
/*
* todo:
* test on osx

m = MKtl(\mpk2, "akai-mpkmini2");
m.gui;
m.trace;
m.trace(false);
*/

(
deviceName: "MPKmini2",
protocol: 'midi',
deviceType: 'midiKeyboard',
elementTypes: [\knob, \key, \pad, \bend],
status: (
    linux: "tested and working",
    osx: "unknown",
    win: "tested and working"),

idInfo: "MPKmini2",

// hardwarePages: [1, 2, 3, 4],

deviceInfo: (
    vendorURI: 'http://www.akaipro.com/product/mpk-mini-mkii',
    manualURI: 'http://6be54c364949b623a3c0-4409a68c214f3a9eeca8d0265e9266c0.r0.cf2.rackcdn.com/988/documents/MPK%20mini%20-%20User%20Guide%20-%20v1.0.pdf',
    features: [\pianoKey, \pad, \knob, \bender],
    notes:
    "Uses only ```Program 1```.\n"
    "To use the other programs use first: [MPK MiniMKII editor](http://www.akaipro.com/product/mpk-mini-mkii#downloads)\n"
	"avoiding more mapping overlaping as occours in the defaults.\n"
    "Accidental ```Prog-Change``` activation on the device needs to be reverted by ```Bank A/B```.\n",
	longName: "AKAI MPKmini mk2"
),

elementsDesc: (
    shared: (midiChan: 0),
    elements:[

		// ------- bend ------------
        ( key: \bend,
            midiMsgType: \bend, elementType: \bender, spec: \midiBend, style: (row: 0, column:0, width: 1.01)
        ),

        // ------ pad BANK A -------------
        (
            key: \padA,
            shared: ( elementType: \pad, spec: \midiVel, midiMsgType: \noteOn, groupType: \noteOnOffBut ),
            elements: ( 44..51 ).collect{ |num, i|
                (
                    key: (i+1).asSymbol,
                    shared: ( midiNum: num, style:( row: 1 - (i div:4), column: 1 + (i % 4)) )
                )
            }
        ),

        // ------ pad BANK B -------------
        (
            key: \padB,
            shared: ( elementType: \pad, spec: \midiVel, midiMsgType: \noteOn, groupType: \noteOnOffBut ),
            elements: ( 32..39 ).collect{ |num, i|
                (
                    key: (i+1).asSymbol,
                    shared: ( midiNum: num, style:( row: 3.5 - (i div:4), column: 1 + (i % 4)) )
                )
            }
        ),

        // ------ knob -------------
        (
            key: \kn,
            shared: ( elementType: \knob, spec: \midiCC, midiMsgType: \cc ),
            elements: ( 1..8 ).collect{ |num, i|
                (
                    key: (i+1).asSymbol,
                    midiNum: num, style:( row: i div:4, column: i % 4 + 5 )
                )
            }
        ),

        //////// piano key //////////
        (
            key: \pkey,
            shared: ( elementType: \pianoKey, groupType: \noteOnOff, spec: \midiVel ),
            elements:
            (0..120).collect { |num, i|
                var pos = Piano.pos( num % 48, 0);
                (
                    key: i.asSymbol,
                    shared: (
                        midiNum: num, groupType: \noteOnOff,
                        style: (
                            row: (9 - (i div: 48 * 2)) + (pos.y * 0.9),
                            column: pos.x * 0.8 % 25,
                            color: pos.color,
                            height: 1.2,
                        )
                    )
                )
            }
        ),

    ]
)
);
