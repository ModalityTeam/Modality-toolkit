// A simple modality description for the Launchpad Mini Mk1 (might work with later models as well)
/*

// Download drivers here: https://downloads.novationmusic.com/novation/launchpad-mk1/launchpad-mini-mk1

// Init
k = MKtl('yo', 'midi_5_launchpad_mini');

// Trace
k.trace(true)

// light up when pushed
k.elAt('pad').action_({|el|  (el.type == \button).if({ el.value = 1 }, { el.value = 0}) });

// Randomize pad light
Routine({loop{ 0.1.wait; k.elAt('pad').doRecursive({|el| (el.type == \button).if{el.value = 0.25.coin.asInteger } }) }}).play

*/
(
deviceName: "Launchpad Mini",
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
                name = name.asSymbol;
                (key: name, midiNum: ccNum, style: (row: 0, column: name))
            }
		),
		(
			key: \pad,
			shared: (\elementType: \button, \spec: \midiBut, \ioType: \inout, groupType: \noteOnOff),
            elements: [(0..9),
            (16..24),
            (32..40),
            (48..56),
            (64..72),
            (80..88),
            (96..104),
            (112..120)]
            .flat.collect{|num|
                (
                    (
                        key: num,
                        midiNum: num,
                        style: (row: num + 1, column: num % 9)
                    )
                )
            }
		),
	]
)
)
