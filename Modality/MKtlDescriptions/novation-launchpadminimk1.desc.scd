// A simple modality description for the Launchpad Mini Mk1 (might work with later models as well)
/*

// Download drivers here: https://downloads.novationmusic.com/novation/launchpad-mk1/launchpad-mini-mk1

// Init
k = MKtl('yo', "novation-launchpadminimk1");

// Trace
k.trace(true)

// light up when pushed
k.elAt('pad').action_({|el|  (el.type == \button).if({ el.value = 1 }, { el.value = 0}) });

// Lights' colors are controlled via velocity
(
var midiout = k.device.midiOut;
[
    // Rows
    (0..8),
    (16..24),
    (32..40),
    (48..56),
    (64..72),
    (80..88),
    (96..104),
    (112..120)
].flatten.do{|noteNum|
    // Velocity = color
    // Random velocity = random color
    var velocity = rrand(0,127);
    midiout.noteOn(0, noteNum, velocity)
}
)

// Randomize pad light
Routine({loop{ 0.1.wait; k.elAt('pad').doRecursive({|el| (el.type == \button).if{el.value = 0.25.coin.asInteger } }) }}).play

*/
(
deviceName: "launchpadmini",
protocol: \midi,
deviceType: \launchpad,
elementTypes: [\button],
status: (
    linux: "",
    osx: "",
    win: "unknown"),

    idInfo: "Launchpad Mini",

    deviceInfo: (
        vendorURI: "",
        manualURI: "",
        // description: "",
        features: [
            "64 multi-colour backlit buttons",
            "8 arrow buttons",
            "8 other buttons",
        ],
        // notes: "",

        longName: "novation launchpad mini mk1"
    ),
    elementsDesc: (
        shared: (\midiChan: 0),
        elements: [
            (
                key: \bt,
                shared: (\midiMsgType: \cc, \elementType: \button,
                    \spec: \midiBut, \mode: \push, ioType: \inout),
                    elements: (1..8).collect{|name|
                        var ccNum = name + 103;
                        (key: name.asSymbol, midiNum: ccNum, style: (row: 0, column: name-1, width: 1, height: 1))
                    }
                ),
                (
                    key: \pad,
                    shared: (\elementType: \button, \spec: \midiBut, mode: \push, \ioType: \inout, groupType: \noteOnOff),
                    elements: [
                        // Rows
                        (0..8),
                        (16..24),
                        (32..40),
                        (48..56),
                        (64..72),
                        (80..88),
                        (96..104),
                        (112..120)
                    ]
                    .collect{|row, rownum|
                        row.collect{|num, elNum|
                            var elementsInRow = row.size;
                            var column = elNum % elementsInRow;

                            // Last element should be offset, like on the device

                            if(elNum == (elementsInRow - 1), {
                                column = column + 1;
                            });

                            (
                                key: num,
                                midiNum: num,
                                // + 2 to offset from top row
                                style: (row: rownum + 2, column: column, width: 1, height: 1)
                            )
                        }
                    }.flatten
                ),
            ]
    )
)
